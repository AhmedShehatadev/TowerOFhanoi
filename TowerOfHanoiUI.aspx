<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TowerOfHanoiUI.aspx.cs" Inherits="TowerOfHanoi_AlexShehata1.TowerOfHanoiUI" %>

<!DOCTYPE html>
<html>
<head>
    <script src="/scripts/jquery-3.1.1.min.js"></script>
    <meta charset="UTF-8">
    <title>Tower of Hanoi</title>
    <script type="text/javascript">

        "use strict";
        var myTimer = null;
        var moveInfo;
        var moveInc = 1;
        var speed;

        var callStack;

        var barsInfo = [{}, {}, {}, {}, {}];
        var diskCount = 3;

        barsInfo[1].disks = [];
        barsInfo[2].disks = [];
        barsInfo[3].disks = [];
        barsInfo[4].disks = [];
        var diskPosTop, diskPosLeft
        var DiskID = [];

        function SetBars(disknumbers) {
            $('#disks').empty();
            var top = 960;
            var left = 10;
            var width = 350;
            barsInfo[0].disks = [];
            debugger;
            for (var i = 0; i < disknumbers; i++) {
                left += 10;
                top -= 26;
                width -= 10;

                DiskID.push($('#disk' + i));
                barsInfo[0].disks.push("disk" + i);
                var diskhtml = "<div class=" + '\"disk\"' + " "
                    + "id=" + '\"disk' + i + '\"' + "  " +
                "style=" + '\"' + "top:" + top + 'px'
            + ";left:" + left + 'px' + ";width:" + width + 'px;' + 'background-color: orange;' + '\"' + ">"
                + i+ "</div>"
                $('#disks').append(diskhtml)
            }

        }

        window.onload = function () {
           
            $("#noOfDisk").on('input', function (e) {
                diskCount = $(this).val();
                SetBars(diskCount);
            });

            SetBars(diskCount);


            diskPosTop = new Array();
            diskPosLeft = new Array();

            for (var i = 0; i < 5; i++) {
                diskPosTop[i] = $('#disk' + i).css("top") //DiskID[i].style.top;
                diskPosLeft[i] = $('#disk' + i).css("left");
            }

        }


        function executeHanoi() {
            var speed = parseInt(speedSelectList.options[speedSelectList.selectedIndex].value);


            //    Move Disks to start column  
            for (var i = 0; i < 3; i++) {
                $('#disk' + i).css("top", diskPosTop[i]);
                $('#disk' + i).css("left", diskPosLeft[i]);
            }


            callStack = [];  // callStack array is global

            Hanoi(diskCount, 0, 2, 1);

            moveDisk(); // moveDisk takes its parameters from callStack
        }


        function Hanoi(n, from, to, via) {
            if (n == 0) return;

            Hanoi(n - 1, from, via, to);

            callStack.push([from, to]);
            Hanoi(n - 1, via, to, from);

        }


        function moveDisk() {
            if (callStack.length == 0) return;

            var param = callStack.shift();  // Get call parameters from callStack
            // Note: throughout the code, I use fromBar, toBar to refer to towers
            var fromBar = param[0];
            var toBar = param[1];
            debugger;
            var elem = document.getElementById(barsInfo[fromBar].disks.pop());  // find top elemnet in fromBar

            moveInfo = {
                elem: elem,
                fromBar: fromBar,
                toBar: toBar,
                whichPos: "top", // element position property for movement
                dir: -1,  // 1 or -1
                state: "up", // move upward
                endPos: 60    // end position (in pixels) for move upward
            }

            myTimer = setInterval(animateMove, speed); // Start animation
        }

        function animateMove() {
            var elem = moveInfo.elem;
            var dir = moveInfo.dir;

            var pos = parseInt(elem[(moveInfo.whichPos == "left") ? "offsetLeft" : "offsetTop"]);

            if (((dir == 1) && (pos >= moveInfo.endPos)) || ((dir == -1) && (pos <= moveInfo.endPos))) {  // alert(moveInfo.state); 
                if (moveInfo.state == "up") {
                    moveInfo.state = "hor";
                    moveInfo.whichPos = "left";
                    moveInfo.dir = 1;
                    if (moveInfo.fromBar > moveInfo.toBar) moveInfo.dir = -1;
                    //alert("toBar:" + moveInfo.toBar);
                    var toBar = document.getElementById("bar" + moveInfo.toBar);
                    // Next line: 15px is half of tower width    
                    moveInfo.endPos = toBar.offsetLeft - Math.floor(elem.offsetWidth / 2) + 15;
                    return;
                }

                else if (moveInfo.state == "hor") // move down
                {
                    moveInfo.state = "down";
                    moveInfo.whichPos = "top";
                    moveInfo.dir = 1;
                    //alert(elem.offsetHeight);
                    moveInfo.endPos = document.getElementById("bottombar").offsetTop - (barsInfo[moveInfo.toBar].disks.length + 1) * elem.offsetHeight;
                    return;
                }

                else // end of current call to moveDisk, issue next call
                {
                    clearInterval(myTimer);  // cancel timer 
                    barsInfo[moveInfo.toBar].disks.push(elem.id);
                    moveDisk();
                    return;
                }
            }


            // Move Disk
            pos = pos + dir * moveInc;
            elem.style[moveInfo.whichPos] = pos + "px";

            // Move the inside middle image
            if (moveInfo.state == "up") {
                var fromBar = document.getElementById("bar" + moveInfo.fromBar);
                //if (elem.offsetTop < fromBar.offsetTop) {
                //    var x = elem.getElementsByClassName("insideImg")[0].offsetHeight;
                //    if (x > 0) elem.getElementsByClassName("insideImg")[0].style.height = x - moveInc + "px";
                //}
            }

            if (moveInfo.state == "down") {
                var toBar = document.getElementById("bar" + moveInfo.toBar);
                //if (elem.offsetTop > toBar.offsetTop) {
                //    var x = elem.getElementsByClassName("insideImg")[0].offsetHeight;
                //    if (x < 14) elem.getElementsByClassName("insideImg")[0].style.height = x + moveInc + "px";
                //}
            }

        }

    </script>

    <style>
        #container {
            position: absolute;
            top: 30px;
            left: 20px;
            border: 1px solid black;
            height: 1000px;
            width: 760px;
        }

        #bar0 {
            position: absolute;
            top: 120px;
            left: 100px;
            height: 950px;
            width: 30px;
        }

        #bar1 {
            position: absolute;
            top: 120px;
            left: 300px;
            height: 1000px;
            width: 30px;
        }

        #bar2 {
            position: absolute;
            top: 120px;
            left: 500px;
            height: 1000px;
            width: 30px;
        }

        .disk {
            padding: 0;
            margin: 0;
            position: absolute;
            border: 1px solid gray;
            height: 26px;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            border-radius: 4px;
        }

        #bottombar {
            position: absolute;
            top: 950px;
            left: 10px;
            background-color: red;
            border: 1px solid black;
            height: 10px;
            width: 100%;
        }

        label {
            float: right;
            width: 100px;
            margin-top: 8px;
        }

        button {
            float: right;
            margin-top: 26px;
            margin-right: 16px;
            padding: 2px 8px;
            height: 28px;
        }

        img {
            height: 850px;
            bottom:20px;
            top:30px;
            width: 30px;
            position:absolute;
            padding: 0;
            margin: 0;
        }
        /* for towers (bars) */

        .insideImg {
            z-index: 100;
            position: absolute;
            border: 0;
            top: -1px;
            height: 14px;
            width: 30px;
        }
    </style>

</head>
<body>

    <div id="container" style="width: 100%">
        <div id="bar0">
            <img src="Images/Bar.png" />
        </div>

        <div id="bar1">
            <img src="Images/Bar.png" />
        </div>

        <div id="bar2">
            <img src="Images/Bar.png" />
        </div>
        <div id="bottombar"></div>
        <div id="disks">
        </div>
        <button onclick="executeHanoi()">Start</button>
        <label>
            Speed
            <select id="speedSelectList">
                <option value="1">fast</option>
                <option value="10">medium</option>
                <option value="20">slow</option>
            </select>
        </label>

        <label>
            No. of Disks
                <input type="text" style="width: 50px;" id="noOfDisk" />
        </label>
    </div>

</body>
</html>
