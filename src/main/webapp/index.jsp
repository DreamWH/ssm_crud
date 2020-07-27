<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>员工列表</title>
	<%
		pageContext.setAttribute("APP_PATH", request.getContextPath());
	%>
	<!-- web路径：
    不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
    以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
            http://localhost:3306/crud
     -->
	<script type="text/javascript"
			src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
	<link
			href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
			rel="stylesheet">
	<script
			src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<!-- 模态框（Modal） -->
<div class="modal fade" id="empsAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">员工添加列表</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal">
					<div class="form-group">
						<label for="empName" class="col-sm-2 control-label">empName</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" name="empName" id="empName" placeholder="empName">
						</div>
					</div>
					<div class="form-group">
						<label for="email" class="col-sm-2 control-label">email</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" name="email" id="email" placeholder="email">
						</div>
					</div>
					<div class="form-group">
						<label name="gender" class="col-sm-2 control-label">gender</label>
						<div class="col-sm-10">
							<label class="radio-inline">
								<input type="radio" name="gender" id="Radio1" value="M" checked="checked"> 男
							</label>
							<label class="radio-inline">
								<input type="radio" name="gender" id="Radio2" value="F"> 女
							</label>
						</div>
					</div>
					<div class="form-group">
						<label for="dept_add_model" name="did" class="col-sm-2 control-label">deptName</label>
						<div class="col-sm-4">
							<select class="form-control" id="dept_add_model" name="dId">

							</select>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="save_add_emp">保存</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->
</div>
<!-- 搭建显示页面 -->
<div class="container">
	<!-- 标题 -->
	<div class="row">
		<div class="col-md-12">
			<h1>SSM-CRUD</h1>
		</div>
	</div>
	<!-- 按钮 -->
	<div class="row">
		<div class="col-md-4 col-md-offset-8">
			<button class="btn btn-primary" id="emps_add_btn">新增</button>
			<button class="btn btn-danger">删除</button>
		</div>
	</div>
	<!-- 显示表格数据 -->
	<div class="row">
		<div class="col-md-12">
			<table class="table table-hover" id="emps_table">
				<thead>
					<tr>
						<th>#</th>
						<th>empName</th>
						<th>gender</th>
						<th>email</th>
						<th>deptName</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>

	<!-- 显示分页信息 -->
	<div class="row">
		<!--分页文字信息  -->
		<div class="col-md-6" id="empsSum"></div>
		<!-- 分页条信息 -->
		<div class="col-md-6" id="page_nav_area">
		</div>
	</div>
</div>
<script type="text/javascript">
	var totalEmps;
	$(function () {
		to_page(1);
	});
	//列表初始化
	function to_page(pn) {
		$.ajax({
			url:"${APP_PATH }/emps",
			data:"pn="+pn,
			success:function (result) {
				build_emps(result.data.pageInfo.list);
				build_page(result.data.pageInfo);
				build_nav(result.data.pageInfo);
			}
		})
	}
	//员工表格
	function build_emps(data) {
		$("#emps_table tbody").empty();
		$.each(data,function (index,item) {
			var empIdTd = $("<td></td>").append(item.empId);
			var empNameTd = $("<td></td>").append(item.empName);
			var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
			var emailTd = $("<td></td>").append(item.email);
			var deptNameTd = $("<td></td>").append(item.department.deptName);
			var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
					.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
			//为编辑按钮添加一个自定义的属性，来表示当前员工id
			var delBtn =  $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
					.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
			var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
			//append方法执行完成以后还是返回原来的元素
			$("<tr></tr>")
					.append(empIdTd)
					.append(empNameTd)
					.append(genderTd)
					.append(emailTd)
					.append(deptNameTd)
					.append(btnTd)
					.appendTo("#emps_table tbody");
		})
	}
	//记录数
	function build_page(data) {
		$("#empsSum").empty();
		$("#empsSum").append("当前"+data.pageNum+"页,总共"+data.pages + ",页,总"+data.total+"条记录");
		totalEmps = data.total;
	}
	//构建分页条
	function build_nav(data) {
		$("#page_nav_area").empty();
		var ul = $("<ul></ul>").addClass("pagination");
		//构建元素
		var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
		var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
		if(data.hasPreviousPage == false){
			firstPageLi.addClass("disabled");
			prePageLi.addClass("disabled");
		}else{
			//为元素添加点击翻页的事件
			firstPageLi.click(function(){
				to_page(1);
			});
			prePageLi.click(function(){
				to_page(data.pageNum -1);
			});
		}

		//添加首页和前一页 的提示
		ul.append(firstPageLi).append(prePageLi);

		//1,2，3遍历给ul中添加页码提示
		$.each(data.navigatepageNums,function(index,item){
			var numLi = $("<li></li>").append($("<a></a>").append(item));
			if(data.pageNum == item){
				numLi.addClass("active");
			}
			numLi.click(function(){
				to_page(item);
			});
			ul.append(numLi);
		});

		//尾页
		var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
		var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
		if(data.hasNextPage == false){
			nextPageLi.addClass("disabled");
			lastPageLi.addClass("disabled");
		}else{
			nextPageLi.click(function(){
				to_page(data.pageNum +1);
			});
			lastPageLi.click(function(){
				to_page(data.pages);
			});
		}
		//添加下一页和末页 的提示
		ul.append(nextPageLi).append(lastPageLi);

		//把ul加入到nav
		var navEle = $("<nav></nav>").append(ul);
		navEle.appendTo("#page_nav_area");
	}
	//员工添加模态框
	$("#emps_add_btn").click(function () {
		//查询部门
		$("#dept_add_model").empty();
		getDepts();

		$("#empsAddModal").modal({
			backdrop:"static"
		})
	});
	//查询部门信息
	function getDepts() {
		$.ajax( {
			url:"${APP_PATH }/depts",
			type:"GET",
			success:function (result) {
				$.each(result.data.depts,function (index,item) {
					var dept = $("<option></option>").append(item.deptName).attr("value",index).appendTo("#dept_add_model");
				});
			}
		})
	};
	//保存员工按钮
	$("#save_add_emp").click(function () {
		$.ajax({
			url:"${APP_PATH }/emp",
			type:"POST",
			data:$("form").serialize(),
			success:function (res) {
				console.log(res);
				$("#empsAddModal").modal('hide')
				to_page(totalEmps);
			}
		})
	});
</script>
</body>
</html>