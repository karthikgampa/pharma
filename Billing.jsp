<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.io.*,java.util.*, java.text.SimpleDateFormat" session="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Billing</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: hidden;
  background-color: #333;
}
li {
  float: left;
}
li a {
  display: block;
  color: white;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
}
li a:hover {
  background-color: #369;
}
.sidepanel  {
  width: 0;
  position: absolute;
  z-index: 1;
  height: 470px;
  top: 60px;
  left: 10px;
  background-color: #333;
  transition: 0.5s;
  overflow-x: hidden;
  padding-top: 60px;
}
.sidepanel a {
  padding: 20px 8px 8px 32px;
  text-decoration: none;
  font-size: 25px;
  color: #fff;
  display: block;
  transition: 0.3s;
}
.sidepanel a:hover {
  color: #369;
}
.sidepanel .closebtn {
  position: absolute;
  top: 0;
  right: 25px;
  font-size: 36px;
}
.openbtn {
  font-size: 20px;
  cursor: pointer;
  background-color: rgba(255,255,255,0.1);
  color: #333;
  border: none;
  margin-top: 5px;
}
.openbtn:hover {
  color:#369;
}
table,th,td{
border: 1px solid black;
border-collapse: collapse;
}
th,td{
padding: 15px;
}
table{
margin-left: 340px;
margin-top: 30px;
}
body{
background-image: url("sales1.jpg");
background-repeat: no-repeat;
background-size: 100%;
}
.btn{
 border: none;
 text-align: center;
 background-color: rgba(51, 102, 153, 0.7);
 color: white;
 padding: 10px 15px;
 border-radius: 5px;
 width: 90px;
 margin-left: 523px;
}
.btn:hover{
 background-color: rgba(51, 102, 153, 1);
 color: white;
}
.btn1{
 border: none;
 text-align: center;
 background-color: rgba(51, 102, 153, 0.7);
 color: white;
 padding: 10px 15px;
 border-radius: 5px;
 width: 90px;
 margin-left: 663px;
 margin-top: -35px;
}
.btn1:hover{
 background-color: rgba(51, 102, 153, 1);
 color: white;
}
.text{
 width: 400px;
 height: 20px;
 margin-left:350px;
 margin-top: 30px;
}
.amount{
 width: 400px;
 height: 20px;
 margin-left:450px;
 text-align: center;
}
</style>
</head>
<body>
<ul>
  <li><a class="active" href="SalesHome.html">Home</a></li>
  <li><a href="contact.html">Contact</a></li>
  <li><a href="about.html">About</a></li>
    <li style="float: right"><a href="Home.html">Logout</a></li>
</ul>
<div id="mySidepanel" class="sidepanel">
  <a href="#" class="closebtn" onclick="closeNav()">×</a>
  <a href="CustomerDetails.jsp">Customer Details</a>
  <a href="ViewDrugs.jsp">View Drugs</a>
  <a href="Sales.jsp">Sales</a>
</div>
<button class="openbtn" onclick="openNav()"><i class="fa fa-bars fa-lg"></i></button>  
<script>
function openNav() {
  document.getElementById("mySidepanel").style.width = "245px";
}

function closeNav() {
  document.getElementById("mySidepanel").style.width = "0";
}
</script>
<%
	int count = Integer.parseInt(request.getParameter("bxcount"));
    int i,ncount = count;
	while((ncount)%3!=0)
	{
		ncount+=1;
	}
	String med[]= new String[ncount];
	int quant[] = new int[ncount];
	float price[] = new float[ncount]; 
	int dquant[] = new int[count];
	
	int rows = ncount/3;
	for(i=0;i<count;i++){
		med[i] = request.getParameter("med"+i);
		quant[i] = Integer.parseInt(request.getParameter("quant"+i));
	}
	
	response.setContentType("text/html");
	ServletContext sc = getServletContext();
	String url = sc.getInitParameter("url");
	String usname = sc.getInitParameter("username");
	String password = sc.getInitParameter("password");
	
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
	java.util.Date tdate = new java.util.Date();
	System.out.println(tdate);
	String todayDate = (String)sdf.format(tdate);
	System.out.println("After string"+ todayDate);
	String customername = (String)session.getAttribute("custname");
	try
	{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection con = DriverManager.getConnection(url,usname,password);
		PreparedStatement ps1;
		ResultSet rs1;
		for(i=0;i<count;i++){
			ps1=con.prepareStatement("select cost,quantity from drugs where name=?");
			ps1.setString(1,med[i]);
			System.out.println("select med value : " + med[i]);
			rs1 = ps1.executeQuery();
			rs1.next();
			price[i] = rs1.getFloat(1);
			dquant[i] = rs1.getInt(2);
		}
		PreparedStatement ps;
		int jm=0,jq=0,jp=0,rs=0;
		for(i=0;i<rows;i++){
			ps = con.prepareStatement("insert into users values(u_id.nextval,?,?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1,customername);
			ps.setString(2,todayDate);
			ps.setString(3,med[jm++]);
			ps.setFloat(4,price[jp++]);
			ps.setInt(5,quant[jq++]);
			ps.setString(6,med[jm++]);
			ps.setFloat(7,price[jp++]);
			ps.setInt(8,quant[jq++]);
			ps.setString(9,med[jm++]);
			ps.setFloat(10,price[jp++]);
			ps.setInt(11,quant[jq++]);
			rs = ps.executeUpdate();
		}
		PreparedStatement ps2;
		for(int j=0;j<count;j++)
		{
		  int quants = dquant[j]-quant[j];
		  System.out.println("Dquant : " + dquant[j]);
		  System.out.println("quant : " + quant[j]);
		  System.out.println(quants);
		  if(quants == 0)
		  {
			ps2 = con.prepareStatement("delete from drugs where name=?");
			ps2.setString(1,med[j]);
			int rs2 = ps2.executeUpdate();
			if(rs2>0)
			    System.out.println("Deleted Successfully!!!");
			else
				System.out.println("Failed");
		  }
		  else
		  {
			  ps2 = con.prepareStatement("update drugs set quantity=? where name=?");
			  ps2.setInt(1,quants);
			  ps2.setString(2,med[j]);
			  System.out.println(med[j]);
			  int rs2 = ps2.executeUpdate();
				if(rs2>0)
				    System.out.println("Updated Successfully!!!");
				else
					System.out.println("Failed");
		  }
		}
		con.close();
		%>
		<div class="text">
		<label> Name : </label>&nbsp<%=customername%>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp
		<label> Date : </label>&nbsp<%=todayDate%><br><br>
		</div>
		<table>
			<tr><th>Medicines</th><th>Price</th><th>Quantity</th><th>Calculated Price </th></tr>
			<%
				for(int k=0;k<count;k++)
				{ %>
					<tr><td><%=med[k]%></td><td><%=price[k]%></td><td><%=quant[k]%></td><td><%=price[k]*quant[k]%></td></tr>
				<% } %>
		</table>
<%	}
	catch(Exception e){
		e.printStackTrace();
	}
	float total=0;
	for(int j=0;j<count;j++){
		total+= quant[j]*price[j];
	}
	System.out.println(total);
	session.setAttribute("total",total);
	session.setAttribute("rows",rows); 
	%>
	
<br><br>
<div class="amount">
<label> TOTAL AMOUNT : </label>&nbsp &nbsp<%=total %>
</div>
<br><br>
<button onclick="window.print()" class="btn">Print</button>	
<form action="SalesHome.html">
<input type="submit" class="btn1" value="Exit">
</form>
</body>
</html>