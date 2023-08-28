<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
    <div id="modifyrk">	
        <%
            set conn=Server.CreateObject ("ADODB.Connection")
            conn.Provider="Microsoft.Jet.OLEDB.4.0"
            conn.Open "C:\lab3+4\score.mdb"
            set rs1=Server.CreateObject ("ADODB.recordset")
            sql="Select s_name, s_id, s_score FROM score"
            rs1.Open sql,conn,1,3

            dim username
            dim score
            dim idname
            username=Request.Form ("username1")
            score=Request.Form ("score")
            idname=Request.Form("userid1")
            
            rs1.addnew
            rs1("s_name")=username
            rs1("s_id")=idname
            rs1("s_score")=score 
            rs1.update 
            
            rs1.close
        %>
    </div>
    <p>
        数据更新完成！
    </p>
</body>
</html>