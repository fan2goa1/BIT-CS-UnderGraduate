var maxtime = 150;
var sttime, sttimeString, edtime, edtimeString;

var div = document.getElementById("background-pop");
var close = document.getElementById("close-button");
var ranklist = document.getElementById("myrk");

function getDate(){
    var h = document.getElementById("greeting");
    var arrayDay = ["日", "一", "二", "三", "四", "五", "六"];
    var date = new Date();
    var time = date.getHours();
    if(time >= 0 && time <= 6){
        h.innerHTML = "凌晨好, 欢迎来到国防知识竞赛测试";
    }
    if (time > 6 && time <= 10){
        h.innerHTML = "早上好, 欢迎来到国防知识竞赛测试";
    }
    else if (time > 10 && time <= 14){
        h.innerHTML = "中午好, 欢迎来到国防知识竞赛测试";
    }
    else if(time > 14 && time <= 18){
        h.innerHTML = "下午好, 欢迎来到国防知识竞赛测试";
    }
    else if (time > 18){
        h.innerHTML = "晚上好, 欢迎来到国防知识竞赛测试";
    }
    h.innerHTML += "<br>"; h.innerHTML += "现在是";
    var localdate = date.toLocaleString();
    var myday = date.getDay();
    h.innerHTML += localdate;
    h.innerHTML += "    星期" + arrayDay[myday];
}
setInterval("getDate()", 1000);


function TimeCountDown(){    
    var h = document.getElementById("LeftTime");
    if(maxtime >= 0){
        h.innerHTML = "距离测试结束还有" + maxtime + "秒";
    }
    else {
        clearInterval(LeftTimePoint);
        alert("时间到！请停止作答！！！");
    }
    if(maxtime == 150){
        sttime = new Date();
        sttimeString = sttime.toLocaleString();
    }
    maxtime --;
}
LeftTimePoint = setInterval("TimeCountDown()", 1000);


var Sumscore = 0;
function GetMyScore(){
    clearInterval(LeftTimePoint);
    edtime = new Date();
    edtimeString = edtime.toLocaleString();

    var idList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38"];
    var answer = ["0", "A", "B", "C", "B", "D", "A", "ACD", "ABD", "F", "T", "八七", "学校"];
    var score = [0, 0, 0, 0, 0, 0];
    var i, j, myans, news;
    news = document.getElementsByClassName("div-content");
    for(i = 1; i <= 8; i ++){
        myans = "";
        for(j = (i - 1) * 4 + 1; j <= (i - 1) * 4 + 4; j ++){
            var x = document.getElementById(idList[j]);
            if(x.checked) myans = myans + x.value;
        }
        if(myans == answer[i]){
            if(i <= 6) score[1] += 10;
            else if(i <= 8) score[2] += 15;
        }
    }//单选题 and 多选题 的 判分
    for(i = 9; i <= 10; i ++){
        myans = "";
        for(j = 32 + (i - 9) * 2 + 1; j <= 32 + (i - 9) * 2 + 2; j ++){
            var x = document.getElementById(idList[j]);
            if(x.checked) myans = myans + x.value;
        }
        if(myans == answer[i]) score[3] += 5;
    }//判断题 的 判分
    for(i = 11; i <= 12; i ++){
        myans = "";
        var x;
        if(i == 11) x = document.getElementById(idList[37]).value;
        if(i == 12) x = document.getElementById(idList[38]).value;
        myans = myans + x;
        if(myans == answer[i]) score[4] = score[4] + 10;
    }
    for(i = 1; i <= 4; i ++) Sumscore += score[i];
    news[0].innerHTML += "您的最终测试成绩为：" + Sumscore + "/120分" + "<br>" + "其中，单选题" + score[1] + "分；多选题" + score[2] + "分；判断题" + score[3] + "分；填空题" + score[4] + "分。<br>" + "开始作答时间：" + sttimeString + "<br>" + "结束作答时间：" + edtimeString + "<br>" + "共用时 " + (150-maxtime) + " 秒。<br>";
    document.getElementsByName("score")[0].value=Sumscore;
	document.getElementsByName("username1")[0].value=document.getElementsByName("txtName")[0].value;
    document.getElementsByName("userid1")[0].value=document.getElementsByName("txtIdnumber")[0].value;
    show();
}

function StopWritting(quizID){
    var x = document.getElementById(String(quizID));
    if(maxtime < 0){
        alert("时间已到，不能再继续作答！");
        x.checked = false;
    }
}

function geturl(){
    var url = window.location.search.substring(1);
    var res = url.match(/mark=1/i);
    if(res == "mark=1"){
        ranklist.style.display = "block";
    }
}
function show(){
    div.style.display = "block";
}
close.onclick = function close(){
    div.style.display = "none";
}
window.onclick = function close(e){
    if(e.target == div){
        div.style.display = "none";
    }
}
