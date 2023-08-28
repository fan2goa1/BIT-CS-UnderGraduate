<% @Language="vbscript" Codepage="65001"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">	
    <link rel="shortcut icon" type="image/x-icon" href="/images/bit.jpg">
    <link rel="stylesheet" href="styles.css">
    <title>竞赛试卷</title>
</head>
<body onload="geturl()">
    <h1 style="text-align: center; margin-top: 50px;">
        国防知识竞赛测试卷
    </h1>
    <div style="margin-left: 50px;">
        <h1 id="greeting" style="margin-left: 60px; font-size: 25px; font-family: 楷体; color:blueviolet;"></h1>
        <h1 id="LeftTime" style="margin-left: 60px; font-size: 20px; font-family: 楷体; color:royalblue;"></h1>
        <h2 style="text-indent: 2em;">
            <em>
                本次测试共有3种题型，题量设置及分数分布如下：<br>
            </em>
            <p style="text-indent: 4em;">
                单选题（6*10=60）、多选题（2*15=30）、判断题（2*5=10）、填空题(2*10=20)，内容包括但不限于国防知识基础、兵器知识等。
            </p>
            
        </h2>
    </div>
    <form action="onlinetest.asp?mark=1" style="margin-left: 50px; margin-right: 50px;" method="POST">
        <p style="font-size: 27px; text-indent: 1em;">
            <label for="name">姓名：</label><input type="text" name = "txtName" id="name" size="20" placeholder="请输入您的姓名" style="height: 25px;">
            <br>
            <div style="margin-left: 28px">
                <label for="idkey">学号：</label><input type="text" name="txtIdnumber" id="idkey" size="20" placeholder="请输入您的10位学号" style="height: 25px;">
            </div>
        </p>
        <p style="font-size: 27px; text-indent: 1em;">一、单选题</p>
        <p>1.中华人民共和国( )，不分民族、种族、职业，家庭出身，宗教信仰，教育程度都有义务依照兵役法的规定服兵役。</p>
        <p>
            <input type="radio" name="q1" id="1" value="A" onclick="StopWritting(1)"><label for="1">A.公民</label>&nbsp;
            <input type="radio" name="q1" id="2" value="B" onclick="StopWritting(2)"><label for="2">B.人民</label>&nbsp;
            <input type="radio" name="q1" id="3" value="C" onclick="StopWritting(3)"><label for="3">C.青年</label>&nbsp;
            <input type="radio" name="q1" id="4" value="D" onclick="StopWritting(4)"><label for="4">D.少年</label>
        </p>
        <p>2.1941 年，皖南新四军军部直属部队等 9 千余人，在叶挺、项英率领下开始北移。1 月 6 日，当部队到达茂林地区时，遭到国民党 7 个师约 8 万人的突然袭击。新四军英勇抗击，激战 7 昼夜，除傅秋涛率领 2000 余人分散突围外，少数被俘，大部壮烈牺牲。军长叶挺被俘，副军长项英、参谋长周子昆突围后遇难，政治部主任袁国平牺牲。这就是震惊中外的（ ），是国民党第二次反共高潮的高峰。
        </p>
        <p>
            <input type="radio" name="q2" id="5" value="A" onclick="StopWritting(5)"><label for="5">A.陈桥驿事变</label>&nbsp;
            <input type="radio" name="q2" id="6" value="B" onclick="StopWritting(6)"><label for="6">B.皖南事变</label>&nbsp;
            <input type="radio" name="q2" id="7" value="C" onclick="StopWritting(7)"><label for="7">C.八一三事变</label>&nbsp;
            <input type="radio" name="q2" id="8" value="D" onclick="StopWritting(8)"><label for="8">D.双十二事变</label>
        </p>
        <p>3.歼-20 是中航工业成都飞机工业集团公司研制的一款具备高隐身性、高态势感知、高机动性等能力的隐形第( )代战斗机（按照西方划分标准）。于 2011年 1 月 11 日在成都黄田坝军用机场实现首飞。2016 年 11 月 1 日，歼-20 参加珠海航展并首次对外进行双机飞行展示。
        </p>
        <p>
            <input type="radio" name="q3" id="9" value="A" onclick="StopWritting(9)"><label for="9">A.四</label>&nbsp;
            <input type="radio" name="q3" id="10" value="B" onclick="StopWritting(10)"><label for="10">B.三</label>&nbsp;
            <input type="radio" name="q3" id="11" value="C" onclick="StopWritting(11)"><label for="11">C.五</label>&nbsp;
            <input type="radio" name="q3" id="12" value="D" onclick="StopWritting(12)"><label for="12">D.六</label>
        </p>
        <p>4.中国人民解放军政治工作的三大原则是：（ ）。</p>
        <p>
            <input type="radio" name="q4" id="13" value="A" onclick="StopWritting(13)"><label for="13">A.官兵一致、军民一致、合法行政</label><br>
            <input type="radio" name="q4" id="14" value="B" style="margin-left: 54px;" onclick="StopWritting(14)"><label for="14">B.官兵一致、瓦解敌军、合法行政</label><br>
            <input type="radio" name="q4" id="15" value="C" style="margin-left: 54px;" onclick="StopWritting(15)"><label for="15">C.合法行政、军民一致、瓦解敌军</label><br>
            <input type="radio" name="q4" id="16" value="D" style="margin-left: 54px;" onclick="StopWritting(16)"><label for="16">D.瓦解敌军、官兵一致、军民一致</label>
        </p>
        <p>5.《战争论》被誉为西方近代军事理论的经典之作，对近代西方军事思想的形成和发展起了重大作用，由（ ）国军事理论家（ ）所著。</p>
        <p>
            <input type="radio" name="q5" id="17" value="A" onclick="StopWritting(17)"><label for="17">A.德 俾斯麦</label>&nbsp;
            <input type="radio" name="q5" id="18" value="B" onclick="StopWritting(18)"><label for="18">B.美 艾森豪威尔</label>&nbsp;
            <input type="radio" name="q5" id="19" value="C" onclick="StopWritting(19)"><label for="19">C.德 克劳塞维茨</label>&nbsp;
            <input type="radio" name="q5" id="20" value="D" onclick="StopWritting(20)"><label for="20">D.英 蒙哥马利</label>
        </p>
        <p>6.洲际弹道导弹发射井由于其体积巨大，导致很容易被敌方提前探知，战时极易遭到打击和摧毁。其往往会于潜射弹道导弹、战略轰炸机共同构成核陆基、海基、天基打击方式，这被称为（ ）。
        </p>
        <p>
            <input type="radio" name="q6" id="21" value="A" onclick="StopWritting(21)"><label for="21">A.核三位一体</label>&nbsp;
            <input type="radio" name="q6" id="22" value="B" onclick="StopWritting(22)"><label for="22">B.饱和攻击</label>&nbsp;
            <input type="radio" name="q6" id="23" value="C" onclick="StopWritting(23)"><label for="23">C.核讹诈</label>&nbsp;
            <input type="radio" name="q6" id="24" value="D" onclick="StopWritting(24)"><label for="24">D.核扩散</label>
        </p>
        <p>&nbsp;</p>
        <p style="font-size: 27px; text-indent: 1em;">二、多选题</p>
        <p>
            7.关于美国海军的中途岛级航空母舰，下列说法正确的是（）。
        </p>
        <p>
            <input type="checkbox" name="q7" id="25" value="A" onclick="StopWritting(25)"><label for="25">A.它是接替埃塞克斯级的下一代舰队航母</label><br>
            <input type="checkbox" name="q7" id="26" value="B" style="margin-left: 54px;" onclick="StopWritting(26)"><label for="26">B.排水量超过了之前建造的所有航母</label><br>
            <input type="checkbox" name="q7" id="27" value="C" style="margin-left: 54px;" onclick="StopWritting(27)"><label for="27">C.建成时是全通直甲板航空母舰</label><br>
            <input type="checkbox" name="q7" id="28" value="D" style="margin-left: 54px;" onclick="StopWritting(28)"><label for="28">D.其中的“珊瑚海”号经历了大规模改装</label>
        </p>
        <p>
            8.以下关于 051 型驱逐舰说法错误的是（）。
        </p>
        <p>
            <input type="checkbox" name="q8" id="29" value="A" onclick="StopWritting(29)"><label for="29">A.该级舰是我国自行设计建造的第一型导弹驱逐舰</label><br>
            <input type="checkbox" name="q8" id="30" value="B" style="margin-left: 54px;" onclick="StopWritting(30)"><label for="30">B.该级舰的设计参考了前苏联 56 型（科特林）级驱逐舰</label><br>
            <input type="checkbox" name="q8" id="31" value="C" style="margin-left: 54px;" onclick="StopWritting(31)"><label for="31">C.该级舰装备了我国自行研发的“上游 1 号”反舰导弹</label><br>
            <input type="checkbox" name="q8" id="32" value="D" style="margin-left: 54px;" onclick="StopWritting(32)"><label for="32">D.该级舰是为了我国第二炮兵部队的建设而设计建造的</label>
        </p>
        <p>&nbsp;</p>
        <p style="font-size: 27px; text-indent: 1em;">三、判断题</p>
        <p>
            9.集束炸弹是在与一般炸弹同样大小的弹体中，装入由数十个到数千个的子炸弹，子炸弹每颗约网球般大小的球体。由飞行器空投之后，在空中分解，借由散布子炸弹到广范的地面造成区域性杀伤。            
        </p>
        <p>
            <input type="radio" name="q9" id="33" value="T" onclick="StopWritting(33)"><label for="33">A.正确</label><br>
            <input type="radio" name="q9" id="34" value="F" style="margin-left: 54px;" onclick="StopWritting(34)"><label for="34">B.错误</label><br>
        </p>
        <p>
            10.当前世界军事领域正在进行一场深刻的新军事变革，变革的核心是实现信息化。            
        </p>
        <p>
            <input type="radio" name="q10" id="35" value="T" onclick="StopWritting(35)"><label for="35">A.正确</label><br>
            <input type="radio" name="q10" id="36" value="F" style="margin-left: 54px;" onclick="StopWritting(36)"><label for="36">B.错误</label><br>
        </p>
        <p>
            11.在党的______会议上毛泽东提出了“枪杆子里出政权”的著名论断。
        </p>
        <p>
            <input type="text" name = "q11" id="37" size="20" placeholder="请输入答案" onclick="StopWritting(37)" style="height: 25px;">
        </p>
        <p>
            12._______的国防教育，是全民国防教育的基础。
        </p>
        <p>
            <input type="text" name = "q12" id="38" size="20" placeholder="请输入答案" onclick="StopWritting(38)" style="height: 25px;">
        </p>

        <input type="hidden" runat="server" name="score"/>
        <input type="hidden" name="username1" />
        <input type="hidden" name="userid1">

        <div style="margin-left: 60px; margin-top: 50px;">
            <input type="button" value="提交" onclick="GetMyScore()" style="width: 70px; height: 35px;">
            <input type="reset" value="重写" style="width: 70px; height: 35px; margin-left: 20px;">
        </div>
        <center>
            <input type="submit" value="查看历史测试成绩" style="width:150px;height:50px;background:chocolate; font-size: 16px; cursor: pointer"/>
        </center>
    </form>
    
    <%
        set conn=Server.CreateObject("ADODB.Connection")
        conn.Provider="Microsoft.Jet.OLEDB.4.0"
        conn.Open  "C:\lab3+4\score.mdb"

        sql="INSERT INTO score (s_name,s_id,s_score)"
        sql=sql & " VALUES "
        sql=sql & "('" & request.Form("username1") & "',"
        sql=sql & "'" & request.Form("userid1") & "',"
        sql=sql & "'" & request.Form("score") & "')"

        on error resume next
        conn.Execute sql,recaffected
        if err<>0 then
            Response.Write("No update permissions!")
        end if

        
        set rs = Server.CreateObject("ADODB.recordset")
            sql="SELECT s_name,s_id,s_score FROM score"
        rs.Open "SELECT * FROM score ORDER BY s_score DESC",conn
    %>

    <div id="background-pop">
        <div id="div-pop">
            <div class="div-top">
                <span id="close-button">× </span>
                <div>测试结果</div>
            </div>
            <div class="div-content">

            </div>
            <div class="div-footer">
                国防知识竞赛
            </div>
        </div>
    </div>
    
    <div id="myrk" style="margin-top: 20px;">
        <h1 style="color: blueviolet; text-align: center; font-size: 30px;">测试成绩排行榜</h1>
        <center>
            <table border='1'>
                <tr>
                    <th style="width: 8em;">编号</th>
                    <th style="width: 8em;">姓名</th>
                    <th style="width: 8em;">学号</th>
                    <th style="width: 8em;">测试成绩</th>
                </tr>
                <%
                    rs.Movefirst
                    do until rs.eof
                        for each x in rs.Fields
                %>
                <td>
                <%
                    Response.Write(x.value)
                %>
                </td>
                <%
                    next
                    rs.MoveNext
                %>
                </tr>
                <%
                    loop
                    rs.close
                    conn.close
                %>
            </table>
        </center>
    </div>


    <p align="center" style=" margin-top: 70px; letter-spacing: 1px; font-size: 15px; margin-bottom: 50px;">
        &copy; copyright2021 版权所有
    </p> 


    <script src="function.js">
        
    </script>

</body>
</html>