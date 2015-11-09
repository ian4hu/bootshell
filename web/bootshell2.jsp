<!doctype html>
<html lang="en">
<head>
    <title>Boot Shell</title>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="https://cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet"/>
    <style type="text/css" media="screen">
        body {
            font-family: "Helvetica Neue", Helvetica, "Microsoft Yahei", "Hiragino Sans GB", "WenQuanYi Micro Hei", sans-serif;
        }

        html {
            position: relative;
            min-height: 100%;
        }

        body {
            /* Margin bottom by footer height */
            margin-bottom: 24px;
        }

        .fix-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            /* Set the fixed height of the footer here */
            height: 24px;
            background-color: #f5f5f5;
        }

        .fix-footer p {
            margin-bottom: 0px;
        }

        .table label {
            margin-bottom: 0px;
        }

        .table tr label {
            height: 100%;
            width: 100%;
        }

        .table .btn-group {
            margin-bottom: -4px;
            margin-top: -4px;
        }
    </style>
    <!--[if lt IE 9]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>

<nav class="navbar navbar-inverse navbar-static-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#page-navbar"
                    aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a href="javascript:;" class="navbar-brand">Web Shell</a>
        </div>

        <div class="collapse navbar-collapse" id="page-navbar">
            <ul class="nav navbar-nav">
                <li class="active"><a href="javascript:;" data-toggle="files">Files</a></li>
                <li><a href="javascript:;" data-toggle="terminal">Terminal</a></li>
                <li><a href="javascript:;" data-toggle="sys-info">System Info</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a class="link-logout" href="javascript:;">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>
<div id="login-dialog" class="container hide" style="margin-top: 5%;">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-primary">
                <div class="panel-heading text-center">
                    Login
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-12">
                            <form id="login-form" method="post" role="form">
                                <div class="form-group">
                                    <input type="text" name="userName" id="userName" tabindex="1" class="form-control"
                                           placeholder="Username" value=""/>
                                </div>
                                <div class="form-group">
                                    <input type="password" name="password" id="password" tabindex="2"
                                           class="form-control" placeholder="Password"/>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-sm-6 col-sm-offset-3">
                                            <input type="submit" name="login-submit" id="login-submit" tabindex="3"
                                                   class="form-control btn btn-primary" value="Log In"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="alert alert-danger">
                                    <ul>
                                        <li>Login failed.</li>
                                        <li>Usename or Password is not match.</li>
                                        <li>You can still
                                            fail <span>5</span> times,
                                            then you will be blocked in <span>30</span> seconds.
                                        </li>
                                        <li>Usename or Password should not be empty.</li>
                                        <li>Too many tries. You need to wait <span>30</span> seconds to be unblocked.
                                        </li>
                                    </ul>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="files-table" class="container-fluid">
    <div class="row">
        <div class="col-sm-9">
            <div class="row">
                <ol class="breadcrumb" style="margin-bottom: 0px;">
                    <li><a href="#">ROOT</a></li>
                    <li><a href="#">Dir1</a></li>
                    <li><a href="#">Dir1</a></li>
                    <li><a href="#">Dir1</a></li>
                    <li><a href="#">Dir1</a></li>
                    <li><a href="#">Dir1</a></li>
                    <li><a href="#">Dir1</a></li>
                    <li class="active"><span>Dir1</span></li>
                </ol>
            </div>
            <div class="row">
                <table class="table table-striped table-hover table-condensed table-bordered">
                    <thead>
                    <tr>
                        <th><label><input type="checkbox" class="select-all"/> All</label></th>
                        <th>Size</th>
                        <th>PERM</th>
                        <th>Operations</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr data-file="file" class="type-file">
                        <td><label><input type="checkbox" name="files[]" value="file"/> bootstrap.jar </label></td>
                        <td>27K</td>
                        <td>-wr</td>
                        <td>
                            <span class="btn-group btn-group-sm">
                            <button title="Delete" class="btn btn-danger btn-delete" data-toggle="modal"
                                    data-target="#delete-modal"><i class="glyphicon glyphicon-trash"></i>
                            </button>
                            <button title="View" class="btn btn-success btn-view"><i
                                    class="glyphicon glyphicon-eye-open"></i></button>
                            <button title="Edit" class="btn btn-info btn-edit">
                                <i class="glyphicon glyphicon-edit"></i></button>
                            <button title="Download" class="btn btn-primary btn-download"><i
                                    class="glyphicon glyphicon-download"></i></button></span>
                        </td>
                    </tr>
                    <tr data-file="file" class="type-file">
                        <td><label><input type="checkbox" name="files[]" value="file"/> bootstrap.jar </label></td>
                        <td>27K</td>
                        <td>-wr</td>
                        <td>
                            <span class="btn-group btn-group-sm">
                            <button title="Delete" class="btn btn-danger btn-delete" data-toggle="modal"
                                    data-target="#delete-modal"><i class="glyphicon glyphicon-trash"></i>
                            </button>
                            <button title="View" class="btn btn-success btn-view"><i
                                    class="glyphicon glyphicon-eye-open"></i></button>
                            <button title="Edit" class="btn btn-info btn-edit">
                                <i class="glyphicon glyphicon-edit"></i></button>
                            <button title="Download" class="btn btn-primary btn-download"><i
                                    class="glyphicon glyphicon-download"></i></button></span>
                        </td>
                    </tr>
                    <tr data-file="file" class="type-file">
                        <td><label><input type="checkbox" name="files[]" value="file"/> bootstrap.jar </label></td>
                        <td>27K</td>
                        <td>-wr</td>
                        <td>
                            <span class="btn-group btn-group-sm">
                            <button title="Delete" class="btn btn-danger btn-delete" data-toggle="modal"
                                    data-target="#delete-modal"><i class="glyphicon glyphicon-trash"></i>
                            </button>
                            <button title="View" class="btn btn-success btn-view"><i
                                    class="glyphicon glyphicon-eye-open"></i></button>
                            <button title="Edit" class="btn btn-info btn-edit">
                                <i class="glyphicon glyphicon-edit"></i></button>
                            <button title="Download" class="btn btn-primary btn-download"><i
                                    class="glyphicon glyphicon-download"></i></button></span>
                        </td>
                    </tr>
                    <tr data-file="file" class="type-file">
                        <td><label><input type="checkbox" name="files[]" value="file"/> bootstrap.jar </label></td>
                        <td>27K</td>
                        <td>-wr</td>
                        <td>
                            <span class="btn-group btn-group-sm">
                            <button title="Delete" class="btn btn-danger btn-delete" data-toggle="modal"
                                    data-target="#delete-modal"><i class="glyphicon glyphicon-trash"></i>
                            </button>
                            <button title="View" class="btn btn-success btn-view"><i
                                    class="glyphicon glyphicon-eye-open"></i></button>
                            <button title="Edit" class="btn btn-info btn-edit">
                                <i class="glyphicon glyphicon-edit"></i></button>
                            <button title="Download" class="btn btn-primary btn-download"><i
                                    class="glyphicon glyphicon-download"></i></button></span>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="fix-footer"><p class="text-center">Boot Shell all rights
    reserved.</p></div>
<script src="https://cdn.bootcss.com/jquery/1.11.3/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script type="text/javascript">
    $(function(){
        var href = window.location.protocol + '//' + window.location.host + window.location.pathname;
        if(window.location.href != href) {
            // force href
            window.location.href = href;
        }
        $('.navbar ul li a').click(function(){
            var link = $(this);
            link.parent().addClass('active').siblings().removeClass('active');
        });
        var page = {};
        page.loginDialog = $('#login-dialog');
        page.fileTable = $('#files-table');
        page.logoutLink = $('.link-logout');
        page.modules = $().add(page.loginDialog).add(page.fileTable);
        page.showLogin = function () {
            page.modules.addClass('hide');
            page.loginDialog.removeClass("hide");
            page.logoutLink.parents("ul").addClass("hide");
        }
        //page.showLogin();
        window.page = page;
        $.ajaxSetup({
            //global: true,
            url: href + '?_x=1'
        });
        $.get(href, {_x: 1}, function (response, status, xhr){
            window.response = response;
            var result = page.processResponseXML(response, status, xhr);
        });
        page.processResponseXML = function (response, status, xhr) {
            var result = {};
            var xml = $(response);
            result.code = parseInt(xml.find('code').text());
            result.message = xml.find('message').text();
            result.dataElement = xml.find('data');
            if (result.code == 403) {
                page.showLogin();
                
            } else {
                page.loginDialog.addClass('hide');
            }
            return result;
        };
    });
</script>
</body>
