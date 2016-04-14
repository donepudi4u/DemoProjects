<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.Map.Entry"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.TreeMap,java.util.Map,java.text.NumberFormat"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    //String version = automation.admin.Support.getVersion();
    String path = request.getContextPath();
    String title = "Process STR Form Web Ver 1.0" ;
    //String host = java.net.InetAddress.getByName(request.getServerName()).getCanonicalHostName().toLowerCase(); 
    //String user1 = request.getRemoteUser();
  String loginUser = request.getRemoteUser();
    String generalStatus = null;
    loginUser = "whitnem";
%><!doctype html>
<html>
    <head>
<!--        <meta charset="utf-8">-->
        <title>Process STR Form</title>
<!--        <link href="media/dataTables/demo_page.css" rel="stylesheet" type="text/css" />
        <link href="media/dataTables/demo_table.css" rel="stylesheet" type="text/css" />
        <link href="media/dataTables/demo_table_jui.css" rel="stylesheet" type="text/css" />-->
        <link href="media/dataTables/jquery-ui.min.css" rel="stylesheet"> 
        <link href="media/dataTables/dataTables.jqueryui.css" rel="stylesheet"> 
        <link href="media/dataTables/style.min.css" rel="stylesheet"> 
        <link href="media/dataTables/root.css" rel="stylesheet"/>
<!--        <link href="media/dataTables/jquery.toolbar.css" rel="stylesheet" />-->
<!--        <link href="media/themes/smoothness/jquery-ui-1.7.2.custom.css" rel="stylesheet" type="text/css" media="all" />-->
<!--         <link href="media/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" media="all" />
         <link href="media/themes/base/jquery-ui.theme.min.css" rel="stylesheet" type="text/css" media="all" />-->
         <script src="scripts/jquery-2.2.0.min.js"></script>
        <script src="scripts/bootstrap.min.js"></script>
        <script src="scripts/jquery.hotkeys.js"></script>
        <script src="scripts/wysiwyg.js"></script>
<!--         <script src="scripts/jquery-2.1.1.min.js" type="text/javascript"></script>
         <script src="scripts/bootstrap.min.js"></script>
-->         <script src="scripts/jquery-ui.min.js" type="text/javascript"></script>
             <script src="scripts/jquery.dataTables.min.js" type="text/javascript"></script>
         <script src="scripts/dataTables.jqueryui.js" type="text/javascript"></script>
         <script src="scripts/jquery.toolbar.js"></script>
<!--        <script src="scripts/jquery.ba-hashchange.min.js" ></script>
        <script src="scripts/jquery.dataTables.min.js" type="text/javascript"></script>
        <script src="scripts/dataTables.jqueryui.js" type="text/javascript"></script>
       <script src="scripts/uielements.js"></script> 
         <script src="scripts/utility.js"></script> 
          <script src="scripts/jquery.ui.redefine.js"></script> 

<!--         <script src="scripts/jquery.ba-hashchange.min.js"></script> -->
<!--        <script src="scripts/jquery.dataTables.min.js" type="text/javascript"></script>
 
<!--        <script src="scripts/jquery.ui.redefine.js"></script> -->
<!--        <script src="scripts/jquery.uploadfile.min.js"></script> 
          <script src="scripts/jquery.form.js"></script> -->
            
<!--          <script src="scripts/bootstrap.js"></script>-->
         
        <style>
/*  #accordion-resizer {
    padding: 10px;
    //width: 1300px;
   width: 97%;
   //height: 95%;    
    height:520px;
  }*/
    
  .STR_TITLE{
      width:100%;
      padding-left:0px;
      padding-right:0px;
  }
</style>
  
        <script>

var  LotsForSTR = [];
var counter=16;

$(function() {
    $( "#Date" ).datepicker();
  });
$(function() {
    $( "#FinalReportDate" ).datepicker();
  });

//Prevents backspace except in the case of textareas and text inputs to prevent user navigation.
$(document).keydown(function (e) {
        var preventKeyPress;
        if (e.keyCode === 8) {
            var d = e.srcElement || e.target;
            switch (d.tagName.toUpperCase()) {
                case 'TEXTAREA':
                    preventKeyPress = d.readOnly || d.disabled;
                    break;
                case 'INPUT':
                    preventKeyPress = d.readOnly || d.disabled ||
                        (d.attributes["type"] && $.inArray(d.attributes["type"].value.toLowerCase(), ["radio", "checkbox", "submit", "button"]) >= 0);
                    break;
                case 'DIV':
                    preventKeyPress = d.readOnly || d.disabled || !(d.attributes["contentEditable"] && d.attributes["contentEditable"].value === "true");
                    break;
                default:
                    preventKeyPress = true;
                    break;
            }
        }
        else
            preventKeyPress = false;

        if (preventKeyPress)
            e.preventDefault();
    });       
  
  $(window).load(function() {
      //wrapUIElements();
      $("button").button();
      
    
      
      //var device;
     var shipselect =  ' <option value="Ship Lot">Ship Lot</option>' +
                               ' <option value="Scrap Lot">Scrap Lot</option>' +
                                '<option value="Partial Scrap Lot">Partial Scrap Lot</option>' + 
                               ' <option value="Terminate Lot">Terminate Lot</option>';
     var scrWfrSelect =  ' <option value=1>1</option>' +
                               ' <option value=2>2</option>' +
                                '<option value=3>3</option>' + 
                               ' <option value=4>4</option>' +
                               ' <option value=5>5</option>' +
                               ' <option value=6>6</option>' +
                                '<option value=7>7</option>' + 
                               ' <option value=8>8</option>' +
                               ' <option value=9>9</option>' +
                               ' <option value=10>10</option>' +
                                '<option value=11>11</option>' + 
                               ' <option value=12>12</option>' +
                               ' <option value=13>13</option>' +
                               ' <option value=14>14</option>' +
                                '<option value=15>15</option>' + 
                               ' <option value=16>16</option>' +
                                ' <option value=17>17</option>' +
                               ' <option value=18>18</option>' +
                               ' <option value=19>19</option>' +
                                '<option value=20>20</option>' + 
                               ' <option value=21>21</option>' +
                               ' <option value=22>22</option>' +
                               ' <option value=23>23</option>' +
                                '<option value=24>24</option>' + 
                               ' <option value=25>25</option>';
                  
var  LotsForSTR1 = ["${replys.get("DeviceL1")}" ,"${replys.get("ProcessL1")}" , "${replys.get("Lot_1")}", "${replys.get("QADispL1")}","${replys.get("PLD_1")}","${replys.get("PEMgrOKSHip1")}","${replys.get("CommentDispL1")}" ];
var  LotsForSTR2 = ["${replys.get("DeviceL2")}" ,"${replys.get("ProcessL2")}" , "${replys.get("Lot_2")}", "${replys.get("QADispL2")}","${replys.get("PLD_2")}","${replys.get("PEMgrOKSHip2")}" ,"${replys.get("CommentDispL2")}" ];
var  LotsForSTR3 = ["${replys.get("DeviceL3")}" ,"${replys.get("ProcessL3")}" , "${replys.get("Lot_3")}", "${replys.get("QADispL3")}","${replys.get("PLD_3")}","${replys.get("PEMgrOKSHip3")}" ,"${replys.get("CommentDispL3")}" ];
var  LotsForSTR4 = ["${replys.get("DeviceL4")}" ,"${replys.get("ProcessL4")}" , "${replys.get("Lot_4")}", "${replys.get("QADispL4")}","${replys.get("PLD_4")}","${replys.get("PEMgrOKSHip4")}","${replys.get("CommentDispL4")}" ];
var  LotsForSTR5 = ["${replys.get("DeviceL5")}" ,"${replys.get("ProcessL5")}" , "${replys.get("Lot_5")}", "${replys.get("QADispL5")}","${replys.get("PLD_5")}","${replys.get("PEMgrOKSHip5")}" ,"${replys.get("CommentDispL5")}" ];
var  LotsForSTR6 = ["${replys.get("DeviceL6")}" ,"${replys.get("ProcessL6")}" , "${replys.get("Lot_6")}", "${replys.get("QADispL6")}","${replys.get("PLD_6")}","${replys.get("PEMgrOKSHip6")}" ,"${replys.get("CommentDispL6")}" ];
var  LotsForSTR7 = ["${replys.get("DeviceL7")}" ,"${replys.get("ProcessL7")}" , "${replys.get("Lot_7")}", "${replys.get("QADispL7")}","${replys.get("PLD_7")}","${replys.get("PEMgrOKSHip7")}","${replys.get("CommentDispL7")}" ];
var  LotsForSTR8 = ["${replys.get("DeviceL8")}" ,"${replys.get("ProcessL8")}" , "${replys.get("Lot_8")}", "${replys.get("QADispL8")}","${replys.get("PLD_8")}","${replys.get("PEMgrOKSHip8")}" ,"${replys.get("CommentDispL8")}" ];
var  LotsForSTR9 = ["${replys.get("DeviceL9")}" ,"${replys.get("ProcessL9")}" , "${replys.get("Lot_9")}", "${replys.get("QADispL9")}","${replys.get("PLD_9")}","${replys.get("PEMgrOKSHip9")}" ,"${replys.get("CommentDispL9")}" ];
var  LotsForSTR10 = ["${replys.get("DeviceL10")}" ,"${replys.get("ProcessL10")}" , "${replys.get("Lot_10")}", "${replys.get("QADispL10")}","${replys.get("PLD_10")}","${replys.get("PEMgrOKSHip10")}","${replys.get("CommentDispL10")}" ];
var  LotsForSTR11 = ["${replys.get("DeviceL11")}" ,"${replys.get("ProcessL11")}" , "${replys.get("Lot_11")}", "${replys.get("QADispL11")}","${replys.get("PLD_11")}","${replys.get("PEMgrOKSHip11")}" ,"${replys.get("CommentDispL11")}" ];
var  LotsForSTR12 = ["${replys.get("DeviceL12")}" ,"${replys.get("ProcessL12")}" , "${replys.get("Lot_12")}", "${replys.get("QADispL12")}","${replys.get("PLD_12")}","${replys.get("PEMgrOKSHip12")}" ,"${replys.get("CommentDispL12")}" ];
var  LotsForSTR13 = ["${replys.get("DeviceL13")}" ,"${replys.get("ProcessL13")}" , "${replys.get("Lot_13")}", "${replys.get("QADispL13")}","${replys.get("PLD_13")}","${replys.get("PEMgrOKSHip13")}" ,"${replys.get("CommentDispL13")}" ];
var  LotsForSTR14 = ["${replys.get("DeviceL14")}" ,"${replys.get("ProcessL14")}" , "${replys.get("Lot_14")}", "${replys.get("QADispL14")}","${replys.get("PLD_14")}","${replys.get("PEMgrOKSHip14")}","${replys.get("CommentDispL14")}" ];
var  LotsForSTR15 = ["${replys.get("DeviceL15")}" ,"${replys.get("ProcessL15")}" , "${replys.get("Lot_15")}", "${replys.get("QADispL15")}","${replys.get("PLD_15")}","${replys.get("PEMgrOKSHip15")}" ,"${replys.get("CommentDispL15")}" ];
var  LotsForSTR16 = ["${replys.get("DeviceL16")}" ,"${replys.get("ProcessL16")}" , "${replys.get("Lot_16")}", "${replys.get("QADispL16")}","${replys.get("PLD_16")}","${replys.get("PEMgrOKSHip16")}" ,"${replys.get("CommentDispL16")}" ];

  LotsForSTR.push(LotsForSTR1);  
  LotsForSTR.push(LotsForSTR2);       
  LotsForSTR.push(LotsForSTR3);  
   LotsForSTR.push(LotsForSTR4);  
  LotsForSTR.push(LotsForSTR5);       
  LotsForSTR.push(LotsForSTR6);  
   LotsForSTR.push(LotsForSTR7);  
  LotsForSTR.push(LotsForSTR8);       
  LotsForSTR.push(LotsForSTR9);  
   LotsForSTR.push(LotsForSTR10);  
  LotsForSTR.push(LotsForSTR11);       
  LotsForSTR.push(LotsForSTR12);  
  LotsForSTR.push(LotsForSTR13);  
   LotsForSTR.push(LotsForSTR14);  
  LotsForSTR.push(LotsForSTR15);       
  LotsForSTR.push(LotsForSTR16);  
  $("#STRtable4").find("input,button,textarea,select").prop("disabled", false);
  //$("#STRtableDisp").find("input,button,textarea,select").prop("disabled", false);
    for(i=1; i<counter; i++){
        // var row;
        // var row2;
        var Scm;
         var ScrWfrLa;
        var ScrWfrLSplit = new Array();
        var PCMDispositiona ;
        var  row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceL' + i + '" name="DeviceL' + i + '"  value =' + LotsForSTR[ i - 1][ 0] + '></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '"  value =' + LotsForSTR[ i - 1][ 1] + '></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot_' + i + '"  value =' + LotsForSTR[ i - 1][ 2] + '></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + '" type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM_' + i + '" name="SCM_' + i + '"  value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '" >Yes</TD></tr>');
        var  row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input disabled="false" style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '"  value =' + LotsForSTR1[ i - 1 , 3] + '></TD ><TD  style="width:100px">' + '<input disabled="false" type="checkbox" id="Prob' + i + '" name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select disabled="false" id= "DispositionL' + i + '" name="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input disabled="false" style="display:table-cell; width:100%;" type="text" id="PLD_' + i + '" name="PLD_' + i + '"  value =' + LotsForSTR[ i - 1][ 4] + '></TD><TD  style="width:100px"><input disabled="false" style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '"  value =' + LotsForSTR[ i - 1][ 5] + '></TD><TD  style="width:100px">' + 
                        '<select disabled="false" multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '" class= "ScrWfrL' + i + '"  >' + 
                       scrWfrSelect + 
                       '</select></TD><TD> <textarea  disabled="false" id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >' + LotsForSTR[ i - 1][ 6] + '</textarea></TD></tr>');
                        if( LotsForSTR[i - 1][0]  !== "" || LotsForSTR[i - 1][1]  !== "" || LotsForSTR[ i - 1][2]   !== "" ){
                             $("#STRtable4").find('tbody').append(row);
                         }
                          if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){ 
                              $("#STRtableDisp").find('tbody').append(row2);
                           }
                           
        switch(i) {
            
            case 1:
                
            if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
                        
                        PCMDispositiona = "${replys.get("DispositionL1")}";
                        $("#DispositionL1").val(PCMDispositiona);
                         ScrWfrLa = "${replys.get("ScrWfrL1")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL1").val(ScrWfrLSplit);
                       
                         if("${replys.get("LotCony1")}" === "on" ){
                            $("#LotCony1").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_1")}";
                        $("#SCM_1").val(Scm);
                        if("${replys.get("Prob1")}" === "on" ){
                            $("#Prob1").prop("checked", true);
                        };
                    }
                 break;
            case 2:
               
               if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
                      
                        PCMDispositiona = "${replys.get("DispositionL2")}";
                        $("#DispositionL2").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL2")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL2").val(ScrWfrLSplit);
                          if("${replys.get("LotCony2")}" === "on" ){
                            $("#LotCony2").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_2")}";
                        $("#SCM_2").val(Scm);
                         if("${replys.get("Prob2")}" === "on" ){
                            $("#Prob2").prop("checked", true);
                        };
                         
               }
               break;
             case 3:
                 
              if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
//                   
                        
                        PCMDispositiona = "${replys.get("DispositionL3")}";
                        $("#DispositionL3").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL3")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL3").val(ScrWfrLSplit);
                         if("${replys.get("LotCony3")}" === "on" ){
                            $("#LotCony3").prop("checked", true);
                         };
                          Scm = "${replys.get("SCM_3")}";
                        $("#SCM_3").val(Scm);
                         if("${replys.get("Prob3")}" === "on" ){
                            $("#Prob3").prop("checked", true);
                        };
               }
                 break;
            case 4: 
                 
             if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  

                        //$("#STRtable1Disp").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL4")}";
                        $("#DispositionL4").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL4")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL4").val(ScrWfrLSplit);
                         if("${replys.get("LotCony4")}" === "on" ){
                            $("#LotCony4").prop("checked", true);
                         };
                          Scm = "${replys.get("SCM_4")}";
                        $("#SCM_4").val(Scm);
                         if("${replys.get("Prob4")}" === "on" ){
                            $("#Prob4").prop("checked", true);
                        };
               }
                break;
            case 5:
                 
               if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
 
                       //$("#STRtableDisp").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL5")}";
                        $("#DispositionL5").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL5")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL5").val(ScrWfrLSplit);
                         if("${replys.get("LotCony5")}" === "on" ){
                            $("#LotCony5").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_5")}";
                        $("#SCM_5").val(Scm);
                         if("${replys.get("Prob5")}" === "on" ){
                            $("#Prob5").prop("checked", true);
                        };
               }
                break;
           case 6:  
               
              if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
      
                        //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL6")}";
                        $("#DispositionL6").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL6")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL6").val(ScrWfrLSplit);
                         if("${replys.get("LotCony6")}" === "on" ){
                            $("#LotCony6").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_6")}";
                        $("#SCM_6").val(Scm);
                         if("${replys.get("Prob6")}" === "on" ){
                            $("#Prob6").prop("checked", true);
                        };
               }
                 break;
            case 7:
                
             if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
 
                      //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL7")}";
                        $("#DispositionL7").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL7")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL7").val(ScrWfrLSplit);
                         if("${replys.get("LotCony7")}" === "on" ){
                            $("#LotCony7").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_7")}";
                        $("#SCM_7").val(Scm);
                         if("${replys.get("Prob7")}" === "on" ){
                            $("#Prob7").prop("checked", true);
                        };
               }
                break;
            case 8:
                 
             if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
     
                        //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL8")}";
                        $("#DispositionL8").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL8")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL8").val(ScrWfrLSplit);
                        if("${replys.get("LotCony8")}" === "on" ){
                            $("#LotCony8").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_8")}";
                        $("#SCM_8").val(Scm);
                         if("${replys.get("Prob8")}" === "on" ){
                            $("#Prob8").prop("checked", true);
                        };
               }
                break;
           case 9:
              
               if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
   
                        //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL9")}";
                        $("#DispositionL9").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL9")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL9").val(ScrWfrLSplit);
                         if("${replys.get("LotCony9")}" === "on" ){
                            $("#LotCony9").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_9")}";
                        $("#SCM_9").val(Scm);
                         if("${replys.get("Prob9")}" === "on" ){
                            $("#Prob9").prop("checked", true);
                        };
               }
                 break;
            case 10: 
                
             if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
   
                        //$("#STRtable12").find('tbody').append(row2);
                         PCMDispositiona = "${replys.get("DispositionL10")}";
                        $("#DispositionL10").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL10")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL10").val(ScrWfrLSplit);
                         if("${replys.get("LotCony10")}" === "on" ){
                            $("#LotCony10").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_10")}";
                        $("#SCM_10").val(Scm);
                         if("${replys.get("Prob10")}" === "on" ){
                            $("#Prob10").prop("checked", true);
                        };
               }
                 break;
             case 11:
                 
              if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
     
                       //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL11")}";
                        $("#DispositionL11").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL11")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL11").val(ScrWfrLSplit);
                         if("${replys.get("LotCony11")}" === "on" ){
                            $("#LotCony11").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_11")}";
                        $("#SCM_11").val(Scm);
                         if("${replys.get("Prob11")}" === "on" ){
                            $("#Prob11").prop("checked", true);
                        };
               }
                 break;
            case 12:  
                
              if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
    
                        //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL12")}";
                        $("#DispositionL12").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL12")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL12").val(ScrWfrLSplit);
                         if("${replys.get("LotCony12")}" === "on" ){
                            $("#LotCony12").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_12")}";
                        $("#SCM_12").val(Scm);
                         if("${replys.get("Prob12")}" === "on" ){
                            $("#Prob12").prop("checked", true);
                        };
               }
                break;
            case 13:
                 
             if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
 
                        //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL13")}";
                        $("#DispositionL13").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL13")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL13").val(ScrWfrLSplit);
                         if("${replys.get("LotCony13")}" === "on" ){
                            $("#LotCony13").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_13")}";
                        $("#SCM_13").val(Scm);
                         if("${replys.get("Prob13")}" === "on" ){
                            $("#Prob13").prop("checked", true);
                        };
               }
                 break;
           case 14:  
                
              if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
   
                        //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL14")}";
                        $("#DispositionL14").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL14")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL14").val(ScrWfrLSplit);
                         if("${replys.get("LotCony14")}" === "on" ){
                            $("#LotCony14").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_14")}";
                        $("#SCM_14").val(Scm);
                         if("${replys.get("Prob14")}" === "on" ){
                            $("#Prob14").prop("checked", true);
                        };
               }
                 break;
            case 15:
                 
             if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
    
                        //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL15")}";
                        $("#DispositionL15").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL15")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL15").val(ScrWfrLSplit);
                        if("${replys.get("LotCony15")}" === "on" ){
                            $("#LotCony15").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_15")}";
                        $("#SCM_15").val(Scm);
                         if("${replys.get("Prob15")}" === "on" ){
                            $("#Prob15").prop("checked", true);
                        };
               }
                break;
            case 16:
                 
              if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
  
                        //$("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL16")}";
                        $("#DispositionL16").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL16")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL16").val(ScrWfrLSplit);
                        if("${replys.get("LotCony16")}" === "on" ){
                            $("#LotCony16").prop("checked", true);
                         };
                         Scm = "${replys.get("SCM_16")}";
                        $("#SCM_16").val(Scm);
                         if("${replys.get("Prob16")}" === "on" ){
                            $("#Prob16").prop("checked", true);
                        };
               }
                break;     
             default:
        }
       
    }
   
  //changing  fields to disabled readlonly depending on the user and status of the STR

var options;
    $('#element').toolbar( options );  
   $('#button').toolbar({
	content: '#toolbar-options',
	position: 'bottom',
	style: 'primary',
	animation: 'flip'
});
//turn on and off inputs based on current status - using disabled feature so non-editable fields do not post back to server when updating STR
var loginUser = 'whitnem';

var status = "${replys.get("Status")}";
//status = "Draft";

status = "Pending Area Approval";
// if loginUser is a member of the approverGroup that is needed then change approval button to "Approve"
//the status would be changed when the owner of the draft clicks the Submit for Area Mgr App button.
if( status === "Pending Area Approval"){
    //determine if login user is an Area approver and if so, change the button title and then when clicked, puts the approval info in the Approvers table
                
                 var obj = {
                add:[]
                 };
                //var pk22 = values["reticle"];
                //var pk33 = values["stock"];
                obj.add[obj.add.length] = {
                    loginUser: loginUser,
                    status: status,
                    site:"${replys.get("Site")}",
                    strArea: "${replys.get("Area")}"
                  };
                //var obj = { part: partVal   };   
                //obj = $("#SearchPart").val();
                if (obj.length!==0) {
                    //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
                   $.ajax({ url:"/STRform_woutMaven/GetApproval",
                    method: "POST",
                    data: JSON.stringify(obj) 
                }).done(function(msg) {
                    alert(msg);
                    //setTable(msg);
                });
            }
    
}

//  if(status ==="Draft" || status === "Pending Area Approval"){
//      $("#STR_TITLE").prop('disabled', false);
//      $("#Area").prop('disabled', false);
//      $("#Dept").prop('disabled', false);
//      $("#TypeChange").prop('disabled', false);
//      $("#opener").prop('disabled', false);
//      $("#ToolQual").prop('disabled', false); 
//      $("#FinalReportDate").prop('disabled', false); 
//      $("#Total_Lots").prop('disabled', true); 
//      $("#Shippable").prop('disabled', true); 
//      $("#ReliabilityRequired").prop('disabled', false); 
//      $("#RelTestButton").prop('disabled', false); 
//      $("#ReliabilityTests").prop('disabled', true); 
//       $("AddtionalTesting").prop('disabled',false); 
//       $("AddtionalTestComment").prop('disabled',false); 
//       $("LotTypeConv").prop('disabled',true); 
//        $("#STRtable4").find("input,button,textarea,select").prop("disabled", true);
//       $("Purpose").prop('disabled',false); 
//       $('#STR_INSTRUCTION').attr('contenteditable', true);
//       $('#STR_successcriteria').prop('disabled',false); 
//       $('#STR_successplan').prop('disabled',false); 
//       //Approver Groups are always disabled but then enabled when updated only and then put into readonly so to update the database
//       $("#STRtableApp").find("input,button,textarea,select").prop('disabled', true);
//        $('ApprovalComments').prop('disabled',true);
//        $('#SCMRecord').attr('contenteditable', false);
//        $('#Attachments').attr('contenteditable', true);
//        $('#PostCompletionComments').attr('contenteditable', false);
//        $('STRtableLotChg').find("input,button,textarea,select").prop('disabled', true);
//        $('#STRtableRburn').find("input,button,textarea,select").prop('disabled', true);
//        $('#Attachments_1').attr('contenteditable', false);
//        $('#STRtableQA').find("input,button,textarea,select").prop('disabled', true);
//        //Table below holds scrape waffer lists
//        $('#STRtableDisp').find("input,button,textarea,select").prop('disabled', true);
//        $('#STRtableQAF').find("input,button,textarea,select").prop('disabled', true);
//        //change buttons title
//        //$('#str_approve').prop('value', 'Submit for Area Mgr. App.');
//        $('#str_approve span').text('Submit for Area Mgr. App.');
//        $('#types_save span').text( 'Save As Draft');
//        $("#str_SCMPC_changeLots").hide();
//        $("#str_reject").hide();
//        $("#str_delete").hide();
//        $("#rejectioncomments").hide();
//        $("#STRtable9").hide(); // this is the rejection table holding the rejection rich text
//        $("#SCMapprovalTitle").hide(); 
//        $("#SCMRecord").hide(); // this is the SCM rich text div
//        $("#poststrattachment").hide();
//        $("#poststrattachment2").hide();
//        $("#PostCompletionComments").hide();// this is the PostCompletion Comment rich text div PostCompletionComments
//        $("#lotchangerecord").hide();
//        $("#STRtableLotChg").hide();
//        $("#strreportattachment").hide();
//        $("#strreportattachment2").hide();
//        $("#Attachments").hide();
//        $("#strdisposition").hide();
//        $("#strdisposition2").hide();
//        $("#STRtableRburn").hide();
//        $("#Attachments_1").hide();
//        $("#STRtableQA").hide();
//        $("#STRtableDisp").hide();
//        $("#STRtableQAF").hide();
//          
//  }
   
   
   //$('#STR_INSTRUCTION').attr('contenteditable', true);
 });
  </script>
  
    </head>
    <body id="dt_example" >
       <div id="toolbar-options" class="hidden">
<!--        <a href="#"><i class="fa fa-plane"></i></a>
        <a href="#"><i class="fa fa-car"></i></a>
        <a href="#"><i class="fa fa-bicycle"></i></a>-->
    </div>
             <% 
                TreeMap<Integer, String> attachments = new TreeMap<>();
                int attachmentCounter = 0;
                
                String richText = request.getParameter("richtext");
                String newRichText = "";
                if (richText!=null) {
                    String aBegin = "<a attachment=\"";
                    String hrefAttr = "\" href=\"";
                    String aEnd = "\">";

                    StringBuilder newText = new StringBuilder();
                    int indx, prevIndx=0;
                    while ((indx = richText.indexOf(aBegin, prevIndx))!=-1) {
                        //Append everything up to now
                        newText.append(richText.substring(prevIndx, indx));

                        //Get file name from attachment attribute
                        prevIndx = indx + aBegin.length();
                        indx = richText.indexOf(hrefAttr, prevIndx);
                        String fileName = richText.substring(prevIndx, indx);

                        //Get attachment body
                        prevIndx = indx + hrefAttr.length();
                        indx = richText.indexOf(aEnd, prevIndx);
                        String fileBody = richText.substring(prevIndx, indx);
                        prevIndx = indx + aEnd.length();

                        //Add attachment to map of attachments
                        attachments.put(attachmentCounter, fileName + " ==> " + fileBody);

                        //Rewrite the link
                        newText.append("<a href=\"");
                        newText.append(attachmentCounter++);
                        newText.append("\">");
                    }
                    newText.append(richText.substring(prevIndx));
                    newRichText = newText.toString();
                }
            %>    
        <div>
<!--         <button onclick="this.blur();typesRefresh();" title="Refresh All Tables.">Refresh</button> -->
         <button class="btn-toolbar" id="setup" onclick="this.blur();setupSelections();"  title="Settings" >New Draft Settings</button> 
         <button class="btn-toolbar" id="types_save" onclick="this.blur();configSave();"  title="Save As Draft." >Save As Draft</button> 
         <button class="btn-toolbar" id="str_print" onclick="this.blur();"  title="Print STR.">Print</button> 
         <button class="btn-toolbar" id="str_modifyLots" onclick="this.blur();configSetCallbacks.addModifyLots();addModifyLots();"  title="Modify Lots." >Add/Modify Lots</button>
         <button class="btn-toolbar" id="str_approve" onclick="this.blur();selectApprover();"  title="Approve" >Approve</button>
         <button class="btn-toolbar" id="str_reject" onclick="this.blur();"  title="Reject." >Reject</button>
         <button  class="btn-toolbar" id="str_delete" onclick="this.blur();"  title="Delete." >Delete</button>
         <button class="btn-toolbar" id="str_SCMPC_changeLots" onclick="this.blur();addModifyLots();"  title="SCM/PC Change Lots." >SCM/PC Change Lots</button>
         <button class="btn-toolbar" id="str_duplicate" onclick="this.blur();"  title="Duplicate STR." >Duplicate STR</button>
<!--         <button id="types_save" onclick="this.blur();configSave();"  title="Save Changes To All Tables.">Save As Draft</button> -->
<!--         <button id="logout" onclick="this.blur();logout1();"  title="Log out of the system" style="vertical-align:top; float: right">Logout</button> -->
<!--       <button id="logout" onclick="this.blur();configLogout();"  title="Log out of the system" style="vertical-align:top; float: right">Logout</button> -->
        </div>
        <p style="text-align:center; font-size:20px"><b> PROCESS SPECIAL TEST REQUEST (STR)</b> </p>
<!--         <div id="config_refresh" title="Refresh Without Saving" style="display:none">
                <p>Are you sure you wish to refresh without saving?</p>
                <div style="text-align:right">
                    <button onclick="$('#config_refresh').dialog('close');configSetCallbacks.refresh();">Yes</button>&nbsp;
                    <button onclick="$('#config_refresh').dialog('close');" autofocus>No</button>
                </div>
          </div>-->
            <div id="config_save" title="Save As Draft" style="display:none">
                <p>Do you want to save your changes?</p>
                <div style="text-align:right">
<!--                    <button onclick="$('#config_save').dialog('close');configSetCallbacks.save();">Yes</button>&nbsp;-->
<!--                    <button onclick="$('#config_save').dialog('close');configSetCallbacks.historyAdd();">Yes</button>&nbsp;-->
                    <button onclick="$('#config_save').dialog('close');configSetCallbacks.save();">Yes</button>&nbsp;
                    <button onclick="$('#config_save').dialog('close');" autofocus>No</button>
                </div>   
             </div>
              <div id="config_logout" title="Logout" style="display:none">
                <p>Do you wish to logout?</p>
                <div style="text-align:right">
<!--                    <button onclick="$('#config_save').dialog('close');configSetCallbacks.save();">Yes</button>&nbsp;-->
                    <button onclick="$('#config_logout').dialog('close');logout1();">Yes</button>&nbsp;
                    <button onclick="$('#config_logout').dialog('close');" autofocus>No</button>
                </div>   
             </div>
       <div id="accordion-resizer" class="ui-widget-content">
        <div id="accordion" >
<!--            <p class="accordion-expand-all"><b><a href="#">Expand all sections</a></b></p>-->
           <h3 class="accordion-header">Main STR Section </h3> 
           
            <!-- The template to display files available for upload -->
           <form   id="myForm" name="myForm" method="post" action="NewClass_multi" enctype="multipart/form-data"     >
<!--<form   id="myForm" method="post" action="NewClass"  >-->
<!--             <button type="submit" >Submit</button>  -->
              
<!--             <form class= "STRform" id="STRform" action="#"  >    -->
            <div id="container">
<!--                <div><b>${mongodb}</b></div>-->
                Site: <input   disabled style="border:none" type="text" id="site" name="site" value ="${replys.get("Site")}"  >
                    
<!--                <i class="str-info">Click on a entry to change.</i><i class="str-updated">(Last Refresh: <span id="str_updated">Never</span>)</i>-->
                <TABLE class= "STRtable"id="STRtable1" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD style="width:90px" bgcolor="lightgray">STR No:</TD>
<!--             "SZMW012516037733"-->
<!--                    \${fn:escapeXml(param.STRNumber)}-->
                     <td style="width:475px"><input   style="display:none;  width:100%;" type="text" id="_id" name="_id" value ="${replys.get("_id")}"  >${replys.get("_id")}</td>
                
                     <TD style="width:70px" bgcolor="lightgray">Status:</TD>
                     <TD  style="width:200px" ><input disabled   style="display:table-cell; width:100%; color: red;" type="text" id="Status" name="Status"  value ="${replys.get("Status")}"></TD>
                    </TR>
                </TABLE>
                 <br>
                 <TABLE class= "STRtable" id="STRtable2" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <TR>
                     <TD style="width:90px" bgcolor="lightgray">STR Title:</TD>
                     <TD style="width:770px" colspan="3"><input name="STR_TITLE" id="STR_TITLE"    type='text' style="display:table-cell; width:100%;"   value="${replys.get("STR_TITLE")}"  ></TD>
                    </TR>
                    <TR>
                     <TD style="width:90px" bgcolor="lightgray">Engineer:</TD>
                    <TD style="width:450px" ><input disabled name="Engineer" id="Engineer" style="display:table-cell; width:100%;" type='text' value="${replys.get("Engineer")}" ></TD>
                    <TD style="width:70px" bgcolor="lightgray">Sign-Off Date:</TD>
                    <TD style="width:200px" ><input disabled="true" name="Date" id="Date" type="text" style="display:table-cell; width:100%;"  value="${replys.get("Date")}"></TD>
                     </TR>
                    <TR>
                     <TD style="width:90px"  bgcolor="lightgray">Extension:</TD>
                    <TD style="width:450px" ><input  name="Ext" id="Ext" style="display:table-cell; width:100%;" type='text' value="${replys.get("Ext")}"/></TD>
                    <TD style="width:70px" bgcolor="lightgray">Area:</TD>
                    <TD style="width:200px" ><input disabled style="display:table-cell; width:100%;" type="text" id="Area" name="Area"  value ="${replys.get("Area")}" ></TD>
                    </TR>
                    <TR>
                     <TD style="width:90px"  bgcolor="lightgray">Dept:</TD>
                    <TD style="width:450px" ><input  id="Dept" name="Dept" style="display:table-cell; width:100%;" type='text' value="${replys.get("Dept")}"/></TD>
                    <TD style="width:70px" bgcolor="lightgray">Final Report Date:</TD>
                    <TD style="width:200px" ><input style="display:table-cell; width:100%;" name="FinalReportDate" id="FinalReportDate" type="text" value="${replys.get("Final_Report_Date")}" ></TD>
                    </TR>
                     <TR>
                    <TD style="width:90px" bgcolor="lightgray">Type of Change:</TD>
                    <TD style="width:720px" colspan="3" ><button id="opener" class="opener" type="button" >Type Change</button><input style="border: 0px solid #000000;" name="TypeChange" id="TypeChange" type="text" value= "${replys.get("TypeChange")}" > <textarea  id="ChangeText"  readonly name="ChangeText"  style="border: none"  ROWS=2  > ${replys.get("ChangeText")}</textarea></TD>
<!--                    <input   id="typechangeselected" style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='Button - Selected Type of Change'/>-->
                    </TR>
                   <TR>
                    <TD style="width:90px" bgcolor="lightgray">Tool Qualification Selection:</TD>
                    <TD style="width:720px"  colspan="3"  >
                        <select name="ToolQual" id="ToolQual">        
                                <option value="1APX01">1APX01</option>
                                <option value="1APX02">1APX02</option>
                                <option value="1APX03">1APX03</option>
                                <option value="1APX04">1APX04</option>
                        </select>
                    </TD>
                    </TR>
                   <TR>
                   <TD style="width:90px" bgcolor="lightgray">Abstract:</TD>
                    <TD  style="width:720px"  colspan="3"  ><input disabled="true" style="width:100%; padding-left:0px; padding-right:0px;" type='text'id="Abstract" name="Abstract"  value= "${replys.get("Abstract")}" /></TD>
                    </TR>
                </TABLE>                    

  
        <ul>


        </ul>
 
<!--        </div>
        
        
        <h3 class="accordion-header">Lots Designated for STR </h3>
         <div id="container4">-->
<p><b>Lots Designated for STR:</b></p>
<!--              <i class="table-info">  </i> <i class="table-updated"> (Last Refresh: <span id="history_updated">Never</span>)</i>-->
             <TABLE class= "STRtable" id="STRtable3" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <TR>
                    <TD style="width:90px"  bgcolor="lightgray">Total Lots Requested:</TD>
                    <TD style="width:470px" ><input  id="Total_Lots" name="TotalLots" style="display:table-cell; width:100%;" type='text' value= "${replys.get("Total_Lots")}" ></TD>
                    <TD style="width:90px" bgcolor="lightgray">Are Lots Shippable?:</TD>
                    <TD style="width:200px" ><input id="Shippable" name="Shippable" style="display:table-cell; width:100%;" type='text'value= "${replys.get("Shippable")}" ></TD>
                     </TR>
                    <TR>
                    <TD style="width:90px" bgcolor="lightgray">Reliability Required:</TD>
                    <TD style="width:470px" > <input type="radio" id="ReliabilityRequired" name="ReliabilityRequired" value= "${replys.get("ReliabilityRequired")}">Yes<input type="radio" id="ReliabilityRequired1" id="ReliabilityRequired1" value= "${replys.get("ReliabilityRequired_1")}">No</TD>
                    <TD style="width:90px" bgcolor="lightgray">Select Reliability Tests That Are Required:</TD>
                    <TD style="width:200px" ><button id="RelTestButton" class="RelTestButton" type="button" onclick="this.blur();selectTests();">Select</button><input id="ReliabilityTests" name="ReliabilityTests" style="display:table-cell; width:100%;" type='text' value= "${replys.get("ReliabilityTests")}" ></TD>
                    </TR>
                    <TR>
                    <TD style="width:90px" bgcolor="lightgray">Number of splits (2 Days/split):</TD>
                    <TD style="width:470px"  ><input  id="AddtionalTesting" name="AddtionalTesting" style="display:table-cell; width:100%;" type="text"  value= "${replys.get("AdditionalTesting")}" ></TD> 
                    <TD style="width:90px" bgcolor="lightgray">Comment:</TD>
                    <TD style="width:200px"  ><input  id="AddtionalTestComment" name="AddtionalTestComment" style="display:table-cell; width:100%;" type='text' value= "${replys.get("AddtionalTestComment")}" ></TD>
                    </TR>
                     <TR>
                    <TD style="width:90px" bgcolor="lightgray">Lots Converted to Proper Lot Type:</TD>
                    <TD style="width:760px" colspan="3"  ><input  id="LotTypeConv" name="LotTypeConv" style="display:table-cell; width:100%;" type='text' value= "${replys.get("LotTypeConv")}"><input  id="LotTypeConvDate" name="LotTypeConvDate" style="width:100%; padding-left:0px; padding-right:0px;" type='text' value= "${replys.get("LotTypeConvDate")}"></TD>
                    </TR>
                </TABLE>
               <br>
                 <TABLE class= "STRtable" id="STRtable4" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <th colspan="6" >LOTS DESIGNATED FOR STR</th>
                     <TR>
                     <th style="width:140px" bgcolor="lightgray">Device Full Pathname</th>
                    <th  style="width:110px"bgcolor="lightgray">Process</th>
                    <th  style="width:110px"bgcolor="lightgray">Lot No.</th>
                    <th  style="width:40px"bgcolor="lightgray" >SCM/PC Approval</th>
                     <th  style="width:240px"bgcolor="lightgray">Approver</th>
                     <th  style="width:130px" bgcolor="lightgray">Lot Converted to Proper Lot Type</th>
                       </TR>
                      
                </TABLE>
            <br>
            <p><b>Purpose of STR:</b></p>
            <TABLE class= "STRtable" id="STRtable5" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:870px" >Type the purpose, including the benefits and risks, for this STR inside this box.</th>
                      <TR >
                          <TD class="tdpurpose" > <textarea  style="border: none" id="Purpose" name="Purpose"   ROWS=1 >${replys.get("Purpose")}</textarea></TD>
                      </TR>
            </table>
            <br>


<p><b>STR Instructions: </b><div class="strinstructions" id="STR_INSTRUCTION" name="STR_INSTRUCTION" contenteditable="true" style="width: 870px;height: 100px;overflow: auto;border: 1px solid black"rows = "4">${replys.get("STR_INSTRUCTION")}</div></p>
          

          <br>
            <p><b>Success Criteria:</b></p>
            <TABLE class= "STRtable" id="STRtable6" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:870px" >What is the success criteria (null and alternative hypothesis) STR results must meet to move to the next stage</th>
                      <TR>
                          <TD  > <textarea  style="border: none"  name="STR_successcriteria" id="STR_successcriteria" ROWS=1 >${replys.get("STR_successcriteria")}</textarea></TD>
                      </TR>
            </table> 
           <br>
          <p><b>Success Plan:</b></p>
            <TABLE class= "STRtable" id="STRtable7" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:870px" >If successful what is the next phase?</th>
                      <TR >
                          <TD > <textarea disabled style="border: none"  ROWS=1 name="STR_successplan" id="STR_successplan" >${replys.get("STR_successplan")}</textarea></TD>
                      </TR>
            </table>   
            <br>
            <p><b>Approver Groups:</b></p>
             <TABLE  class= "STRtable" id="STRtableApp" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                 <TR>
                 <th style="width:130px" bgcolor="lightgray">Approver Groups:</th>
                <th  style="width:470px"bgcolor="lightgray">Approvers:</th>
                <th  style="width:100px"bgcolor="lightgray">Action:</th>
                <th  style="width:150px"bgcolor="lightgray" >Date:</th>
                 </TR>
                 <TR>
                 <TD style="width:130px"><input  id="Group1" name="Group1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group1")}' ></TD>    
                 <TD  style="width:470px"><input  id="Who1" name="Who1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who1")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken1" name="ActionTaken1" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken1")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate1" name="ActionDate1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate1")}' "></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group2" name="Group2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group2")}' ></TD>    
                 <TD i style="width:470px"><input  id="Who2" name="Who2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who2")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken2" name="ActionTaken2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken2")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate2" name="ActionDate2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate2")}' ></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group3" name="Group3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group3")}' ></TD>    
                 <TD i style="width:470px"><input  id="Who3" name="Who3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who3")}'></TD>
                 <TD  style="width:100px"><input  id="ActionTaken3" name="ActionTaken3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken3")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate3" name="ActionDate3"  style="display:table-cell; width:100%;"type='text'value='${replys.get("ActionDate3")}' ></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group4" name="Group4"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group4")}' ></TD>    
                <TD i style="width:470px"><input  id="Who4" name="Who4"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who4")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken4" name="ActionTaken4"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionTaken4")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate4" name="ActionDate4"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionDate4")}' ></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group5" name="Group5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group5")}' ></TD>    
                 <TD i style="width:470px"><input  id="Who5" name="Who5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who5")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken5" name="ActionTaken5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken5")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate5" name="ActionDate5"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionDate5")}' ></TD>    
                 </TR>
                 <TR>
                 <TD style="width:130px"><input  id="Group6" name="Group6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group6")}' ></TD>    
                <TD i style="width:470px"><input  id="Who6" name="Who6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who6")}'  ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken6" name="ActionTaken6"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionTaken6")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate6" name="ActionDate6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate6")}' ></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group7" name="Group7"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group7")}' ></TD>    
                 <TD i style="width:470px"><input  id="Who7" name="Who7"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who7")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken7" name="ActionTaken7" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken7")}' "></TD>    
                  <TD  style="width:150px"><input  id="ActionDate7" name="ActionDate7" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate7")}'></TD>    
                 </TR>
           </TABLE>
          <br>
             <p id="rejectioncomments"><b>Rejection Comments:</b></p>
            <TABLE class= "STRtable"id="STRtable9" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD  style="width:870px" ><textarea  disabled style="border: none"  id="ApprovalComments" name="ApprovalComments" ROWS=1 >${replys.get("ApprovalComments")}</textarea></TD>
                    </TR>
                </TABLE>
           <br> 
           <p id="SCMapprovalTitle" ><b>SCM/PC Approval Record:</b></p>
            <p><div    class="strinstructions" name="SCMRecord"  id="SCMRecord" contenteditable="true" style="width: 670px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("SCMRecord")}</div></p>
           <br>
            <p id="lotchangerecord"><b>Lot Change Record:</b></p>
            <TABLE  class= "STRtable"id="STRtableLotChg" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD style="width:100px" bgcolor="lightgray">Change Request Comments:</TD>
                     <TD style="width:770px" ><textarea  disabled  style="border: none"  ROWS=1  id="ChangeRequestComment"  name="ChangeRequestComment">${replys.get("ChangeRequestComment")}</textarea></TD>
                     </TR>
                     <TR>
                     <TD style="width:100px" bgcolor="lightgray">Lot Change Comments:</TD>
                     <TD style="width:770px" ><textarea  disabled style="border: none"  ROWS=1 id="LotChangeComment" name="LotChangeComment" >${replys.get("LotChangeComment")}</textarea></TD>
                    </TR>
                </TABLE>
            <br>
           <p id="strreportattachment"><b>STR Report Attachment:</b></p>
            <p id="strreportattachment2">Attach STR Report.</p>
           <p><div id="Attachments" name="Attachments"  id="Attachments" class="strinstructions" contenteditable="true" style="width: 670px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("Attachments")}</div></p>
           <br>
          <p id="poststrattachment"><b>Post Completion Comments:</b></p>
            <p id="poststrattachment2">Comments to be added after a STR has completed.</p>
           <p><div id="PostCompletionComments" name="PostCompletionComments" contenteditable="true" class="strinstructions"  style="width: 870px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("PostCompletionComments")}</div></p>            
            
           <br>
            <p id="strdisposition"><b>STR Disposition:</b></p>
            <p id="strdisposition2" ><Font COLOR=RED  >->Reliability Test Burn In Boards:</Font></p> 
            <TABLE class= "STRtable1" id="STRtableRburn" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
            <TR>
            <TD style="width:100px"  bgcolor="lightgray">Reliability Test Required?</TD>
            <TD  style="width:100px" ><input type="radio" name="RelTestReqDisp" id="RelTestReqDispY" value="yes"  >Yes<input type="radio" name="RelTestReqDisp" id="RelTestReqDispN" value="no">No</TD>
            <TD style="width:50px" bgcolor="lightgray">Rel:</TD>
            <TD  style="width:300px" ><input id="RelTestMgr" name="RelTestMgr"  style="display:table-cell; width:100%;" type='text' value='${replys.get("RelTestRelMgr")}' ></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input id="RelTestDate" name="RelTestDate"  style="display:table-cell; width:100%;" type='text' value='${replys.get("RelTestDate")}' ></TD>
             </TR>
             <TR>
            <TD style="width:100px"  bgcolor="lightgray">Reliability Tests:</TD>
            <TD  colspan="5" style="width:630px" ><input id="RelTests" name="RelTests" style="display:table-cell; width:100%;" type='text' value='${replys.get("RelTestsList")}' ></TD>
             </TR>
              <TR>
            <TD style="width:100px"  bgcolor="lightgray">Rel Manager Comment About Reliability Tests:</TD>
            <TD  colspan="5" style="width:630px" ><input disabled id="Rel1Comment" name="Rel1Comment"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Rel1Comment")}' ></TD>
             </TR>
            </table>
            <p>Attach Reliability Report:<div id="Attachments_1" name="Attachments_1"  contenteditable="true" style="width: 670px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("Attachments_1")}</div></p>   
            <TABLE class= "STRtable1" id="STRtableQA" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
            <TR>
            <TD style="width:100px"  bgcolor="lightgray">For Delivery to Customer</TD>
            <TD  style="width:100px" ><input   type="radio"  id="CustDeliveryY" name="CustDelivery" value="yes">Yes<input type="radio"  id="CustDeliveryN" name="CustDelivery" value="no">No</TD>
            <TD style="width:50px" bgcolor="lightgray">QA:</TD>
            <TD style="width:300px" ><input  id="CustDelQAMgr"  name="CustDelQAMgr"  style="display:table-cell; width:100%;" type='text' value='${replys.get("CustDelQAMgr")}' ></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input   id="CustDelDate"  name="CustDelDate"  style="display:table-cell; width:100%;" type='text' value='${replys.get("CustDelDate")}' ></TD>
             </TR>
             <TR>
            <TD style="width:100px"  bgcolor="lightgray">Final Release to Production</TD>
            <TD  style="width:80px" ><input type="radio" id="RelToProductionY" name="RelToProduction" value="yes">Yes<input type="radio" id="RelToProductionN" name="RelToProduction" value="no" >No</TD>
            <TD style="width:50px" bgcolor="lightgray">QA:</TD>
            <TD  style="width:300px" ><input id="RelProdQAMgr"  name="RelProdQAMgr"  style="display:table-cell; width:100%;" type='text' value='${replys.get("RelProdQAMgr")}' ></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input  id="RelProdDate"   name="RelProdDate"  style="display:table-cell; width:100%;" type='text' value='${replys.get("RelProdDate")}' ></TD>
             </TR>
             <TR>
            <TD style="width:200px" colspan="2"  bgcolor="lightgray">QA Manager Comment About Deliverable Lots:</TD>
            <TD colspan="4" style="width:530px" ><textarea    style="border: none"  id="QA1Comment" name="QA1Comment" ROWS=1 >${replys.get("QA1Comment")}</textarea></TD>
             </TR>
              <TR>
            <TD style="width:200px"  colspan="2" bgcolor="lightgray">QA Manager Comment About Final Release to Prod</TD>
            <TD  colspan="5" style="width:530px" <textarea    style="border: none"  id="QA2Comment" name="QA2Comment" ROWS=1 >${replys.get("QA2Comment")}</textarea></TD>
             </TR>
            </table>
            <br>
            <div class="table12">
             <TABLE class= "STRtable" id="STRtableDisp" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                   <TR>
                     <th style="width:100px" bgcolor="lightgray">Lot Number:</th>
                    <th  style="width:100px"bgcolor="lightgray">Lot Tracked Into STR_INV:</th>
                    <th  style="width:100px"bgcolor="lightgray">PCM Disposition:</th>
                    <th  style="width:100px"bgcolor="lightgray" >PLD Number:</th>
                     <th  style="width:100px"bgcolor="lightgray">PE Mgr OK to Ship Prior to STR Report:</th>
                     <th  style="width:100px" bgcolor="lightgray">Scrap Wafers:</th>
                     <th  style="width:130px" bgcolor="lightgray">Comment:</th>
                  </TR>
             </table>
            </div>
            <br>
             <p  class="qafeedback"><b>QA Feedback Section:</b></p>
            <TABLE  class= "STRtable" id="STRtableQAF" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                <TR >
                     <th style="width:200px" bgcolor="lightgray">STR-REL Submit Date</th>
                     <th style="width:200px" bgcolor="lightgray">QA Response Date:</th>
                     <th style="width:420px" bgcolor="lightgray">QA Response Comments:</th>
                     </TR>
                  <TR >
                       <TD  style="width:200px" ><input   id="STRSubDate"   name="STRSubDate"  style="display:table-cell; width:100%;" type='text' value='${replys.get("STRSubDate")}' ></TD>
                       <TD  style="width:200px" ><input  id="QAFeedbackDate1"   name="QAFeedbackDate1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("QAFeedbackDate1")}' ></TD>  
                       <TD  style="width:420px" ><textarea   style="border: none"  id="QAFeedback1" name="QAFeedback1" ROWS=1 >${replys.get("QAFeedback1")}</textarea></TD>    
                         
                      </TR>
            </table>
             <br>
            <p  class="revisionhistory"><b>Revision History:</b></p> 
            <TABLE   class= "STRtable" id="STRtable14" BORDER="0" CELLPADDING="2" CELLSPACING="2" >
                <tr>
                <TD  style="width:750px" ><textarea   readonly style="border: none"  ROWS=5 id="UpdatedByRevisions" name="UpdatedByRevisions" >'${replys.get("updatedByRevisions")}'</textarea></TD>    
                </tr>
               
            </TABLE>
                  <script>
            //Add textarea (must be textarea to allow large files) after all contenteditable fields to receive HTML during submission
           
  var textareas ;          
            $('[contenteditable]').each(function(i,e) {
                e = $(e);
                e.after($('<textarea>').attr('name',e.attr('name')).hide()).wysiwyg();
                
            });
//            $("#STRtitle").val(<
 //       %= newSTRtitle %>);
//            //Have all forms copy editable content to the adjacent input before submitting
            $('#myForm').on('submit', function() {
                $(this).find('[contenteditable]').each(function(i,e) {
                   
                    e=$(e);
                     
 
                          e.next('textarea').val(e.html());

                  textareas = e;
                });

            });
        </script>
      </div>
            
  </form>
       <div id="selectLots" class="selectLots" style="display: none">        
   <form class= "LotGroup1" id="formAddLots" action="#" title="Add Lots"  style="overflow:hidden" width="auto" >

                  <legend>Search for Appropriate Lots : Enter 4 or more characters for Part or Process Search.</legend> 
                  <TABLE class= "SearchTable"id="SearchTable" BORDER="2" CELLPADDING="2" CELLSPACING="2"  >
                  <TR>
                     <TD style="width:100px" bgcolor="lightgray">Part#:</TD>
                     <TD style="width:100px" colspan="1"><input name="SearchPart" id="SearchPart"    type='text' style="display:table-cell; width:100%;"   value="${replys.get("SearchPart")}"  ></TD>
                    <TD style="width:100px" bgcolor="lightgray"> OR Process:</TD>
                    <TD style="width:100px" colspan="1"><input  name="SearchProcess" id="SearchProcess" style="display:table-cell; width:100%;" type='text' value="${replys.get("SearchProcess")}" ></TD>
                    </tr>
                    <tr>
                    <TD style="width:100px" bgcolor="lightgray">Lots Not Past Stage:</TD>
                    <TD style="width:100px" ><input name="LotsStage" id="LotsStage" type="text" style="display:table-cell; width:100%;"  value="${replys.get("LotsStage")}"></TD>
                     <TD style="width:100px" bgcolor="lightgray">Exclude PLD Lots:</TD>
                    <TD style="width:100px" ><input type="checkbox" id="ExcludePLDs" name="ExcludePLDs" >Yes</TD>
                     </tr>
                    <tr>
                        <TD style="width:100px"   colspan="2" ><button id="ClearSearchEntries" name="ClearSearchEntries" type="button" style="display:table-cell; width:100%;"onclick="this.blur();clearEntries();">Clear Search</button></td>   
                     <TD style="width:100px" colspan="2"><button id="Search" name="Search" type="button" style="display:table-cell; width:100%;" >Search</button></td>
                     </TR>
                  </table>
                     <br>
           <div style="width: 100%;">
               <div id="fromList" class="toolbar" style="width: 50%; float: left;">
                   <caption>
                            Table 1: <i>Select Lots For This STR</i>
                        </caption>
                  <table id="lotList" class="inlineTable" style="display: inline-block; border: 1px solid; float: left;" cellspacing="0"   >
                      
                    <thead>
                        <tr>
                            <th>LOT</th>
                            <th>PORT</th>
                            <th>PROCESS</th>
                        </tr>
                    </thead>
                   <tbody  class="selectable" align="center">

                    </tbody>
                </table>
            </div>    
            <div id="toList" style="width: 50%; float:left;">   
                 <caption>
                            Table 2: <i>Lots Designated For This STR</i>
                        </caption>
                <table id ="lotsToSave" class="inlineTable"  style="display: inline-block; border: 1px solid; float: left;" cellspacing="0"  >
                         <thead>
                        <tr>
                            <th>LOT</th>
                            <th>PORT</th>
                            <th>PROCESS</th>
                        </tr>
                    </thead>
                     <tbody  class="selectable" align="center">

                    </tbody>
                </table>
            </div>
          </div>
        </form>
        </div>             
            <div id="openerform" class="openerform" title="Select Type of Change" style="display: none">
                <form name="opendialog" action="#" id="opendialog">

             <fieldset class="radiogroup" id="radiogroup" name="radiogroup">
                 <legend>Select the appropriate change type</legend> 
                  <p>
                        
                  <input type="radio" id="radio1" name="Type" value="Type 1" /><label for="radio1"><b>Type 1 Change:</b><br> This is a change that might impact cost or capacity, but will most likely not impact electrical performance,reliability or quality. Type 1 changes do not have to be reported to the customer.<br></label>
                  <input type="radio" id="radio2" name="Type" value="Type 2" /><label for="radio2"><b>Type 2 Change:</b><br> This is a change that might impact electrical performance, reliability or cost [yield], fab capacity or quality of the customer's product. A typical type 2 change may require two CCB reviews. This first review will include the results evaluation and implementation plan. A subsequent review may be required upon completion of the evaluation and when the CCB determines that customer notification is required, a PCN [FCD 0673] must be generated by the Project Champion. The PCN must be distributed to all CCB members for review prior to the second CCB meeting.<br></label>
                  <input type="radio" id="radio3" name="Type" value="Type 3" /><label for="radio3"><b>Type 3 Change:</b><br> This is a significant change that will impact electrical performance, reliability, cost [yield], fab capacity or quality of the customer's product. Type 3 changes must be reviewed by the CCB.  Customer notification is required. A PCN [FCD 0673] must be generated by the Project Chanpion and distributed prior to CCB review. The PCN must be distributed to all CCB members prior to CCB review.</label>
                  </p>
             </fieldset>
      </form>
       </div>
       <div id="setupSelect" class="setupSelect" style="display: none">        
                 <form class= "setupSelect" id="setupSelect" action="#" title="Setup New STR"  style="overflow:hidden" width="auto" >
                                 
                   <div style="width: 100%;">
                        <div id="location" class="location" style="width: 20%; float: left;">
                        <legend>Select Location</legend> 
                        <select name="location" id="location" size="4">        
                                <option value="Fab1">Fab1</option>
                                <option value="Fab2">Fab2</option>
                                <option value="Fab3">Fab3</option>
                                <option value="Fab4">Fab4</option>
                        </select>
                        </div>
                  <div id="primaryList" class="primaryList" style="width: 40%; float: left;">
                   <caption>
                             <i>Select Primary Area</i>
                        </caption>
                       <select name="primaryArea" id="primaryArea" size="10">        
                                <option value="APT">APT</option>
                                <option value="Diffusion">Diffusion</option>
                                <option value="ETCH">ETCH</option>
                                <option value="Implant">Implant</option>
                                <option value="MAP">MAP</option>
                                <option value="METAL">METAL</option>
                                <option value="NVL/CMP/WET">NVL/CMP/WET</option>
                                <option value="Photo">Photo</option>
                                <option value="QA">QA</option>
                                <option value="Scribe">Scribe</option>
                        </select>
                     </div>    
                <div id="secondaryList" class="secondaryList" style="width: 40%; float: left;">
                 <caption>
                             <i>Select Secondary Areas</i>
                        </caption>
                    <select name="secondaryArea" id="secondaryArea" multiple="multiple" size="10">        
                                <option value="APT">APT</option>
                                <option value="Diffusion">Diffusion</option>
                                <option value="ETCH">ETCH</option>
                                <option value="Implant">Implant</option>
                                <option value="MAP">MAP</option>
                                <option value="METAL">METAL</option>
                                <option value="NVL/CMP/WET">NVL/CMP/WET</option>
                                <option value="Photo">Photo</option>
                                <option value="QA">QA</option>
                                <option value="Scribe">Scribe</option>
                        </select>
                     </div>    
                   </div>         
                </form>
        </div>
        <div id="selectRTest" class="selectRTest" style="display: none">        
                 <form class= "selectRTest" id="selectRTest" action="#" title="Select Reliability Tests"  style="overflow:hidden" width="auto" >
                   
                <div id="selectRList" class="selectRList" >
               
                        <select name="selectRL" id="selectRL" multiple="multiple" size="4">        
                                <option value="TC/TS">TC/TS</option>
                                <option value="Operating Life">Operating Life</option>
                                <option value="Electromigration">Electromigration</option>
                                <option value="Autoclave">Autoclave</option>
                                
                        </select>
                     </div>    
                   </form>
             </div>   
            <div id="divAapprovalGroup" class="divApprovalGroup" style="display: none">        
                 <form class= "formApprovalGroup" id="formApprovalGroup" action="#" title="Select approvers for sending approval requests"  style="overflow:hidden" width="auto" >
                   <legend>Select approvers</legend>
                         <div id="approvalGList" class="approvalGList" >
                         <select name="selectApprover" id="selectApprover"  size="8"  multiple="multiple">        

                         </select>
                     </div>    
                   </form>
             </div>
           <div id="divNeedSplits" class="NeedSplits" style="display: none">        
                 <form class= "NeedSplits" id="formNeedSplits" action="#" title="Number of Splits Needed"  style="overflow:hidden" width="auto" >
                     <legend>Please enter the number of splits for this STR</legend>
                 </form>    
          </div>
        </div>
      
   
            <script>
 //var typesTable;
 var lotsList;
 var lotsToSave;
 var searchTable;
 var gformAddLots;
 var tr ;
 var clickedRow;
 var option;
 var clickedRowHistory; 
 var nextRowAdd=0;
 var cancelAdd = 0;
 //var heightOffset = 115;
 var editorTest;
    $(document).ready(function () {
        
       if("${replys.get("RelTestReqDisp")}" === "no" ){
        $("#RelTestReqDispN").prop("checked", true);
       };
       if("${replys.get("RelTestReqDisp")}" === "yes" ){
        $("#RelTestReqDispY").prop("checked", true);
      };
       if("${replys.get("CustDelivery")}" === "yes" ){
        $("#CustDeliveryY").prop("checked", true);
       };
       if("${replys.get("CustDelivery")}" === "no" ){
        $("#CustDeliveryN").prop("checked", true);
      };
       if("${replys.get("RelToProduction")}" === "yes" ){
        $("#RelToProductionY").prop("checked", true);
       };
       if("${replys.get("RelToProduction")}" === "no" ){
        $("#RelToProductionN").prop("checked", true);
      };
      lotsList =  $("#lotList").DataTable({
                   // "dom": '<"top">Bifrt',
                    "dom": 'rt',
//                    buttons: [
//                        { text: 'Add' , action: function ( e, dt, node, config ) {typesAdd(); } },
//                        { text: 'Remove' , action: function ( e, dt, node, config ) {typesRemove(); } },
//                        { text: 'Copy' , action: function ( e, dt, node, config ) {typesCopy(); } }
//                    ],
                    
                   // "processing": true,
                    //"paginationType": "full_numbers",
                    "jQueryUI": true,
                    "scrollY":    "100%",
                    "scrollX": "100%",
                    
                   // "scrollCollapse": true, //clears the table - inadvertantly
                    "scrollXInner": "110%",
                    paging: false,
                    "columns": [
                        {"name": "LOT" ,
                            "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"
                        },
                        {"name": "PORT",
                                "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"},
                        {"name": "PROCESS",
                        "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"}
                    ]
                });  
                $('#lotList tbody').on( 'click', 'tr', function () {
                    $(this).toggleClass('selected');
                } );
                //$("div.toolbar").html('<b>Select Lots From the List Below</b>');
                //$("#lotList_wrapper").css("width","50%");
                 lotsToSave =  $("#lotsToSave").DataTable({
                   // "dom": '<"top">Bifrt',
                    "dom": 'rt',
//                    buttons: [
//                        { text: 'Add' , action: function ( e, dt, node, config ) {typesAdd(); } },
//                        { text: 'Remove' , action: function ( e, dt, node, config ) {typesRemove(); } },
//                        { text: 'Copy' , action: function ( e, dt, node, config ) {typesCopy(); } }
//                    ],
                    
                   // "processing": true,
                    //"paginationType": "full_numbers",
                    "jQueryUI": true,
                    "scrollY":    "100%",
                    "scrollX": "100%",
                    
                   // "scrollCollapse": true, //clears the table - inadvertantly
                    "scrollXInner": "110%",
                    paging: false,
                    "columns": [
                        {"name": "LOT" ,
                            "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"
                        },
                        {"name": "PORT",
                                "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"},
                        {"name": "PROCESS",
                        "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"}
                    ]
                });  
                $('#lotsToSave tbody').on( 'click', 'tr', function () {
                    $(this).toggleClass('selected');
                } );
                $(".dataTables_wrapper").css("width","98%"); //this keeps the datatable from using more than 50% of the dialog window
              // $(".dataTables_wrapper").css("width","50%"); //this keeps the datatable from using more than 50% of the dialog window
    });       

var typesRefresh;
var typesAdd;
var typesCopy;
var changeType;
var addModifyLots;
var addLotsToSTR;
var typesRemove;
var select1;
var historyRemove;
var setupSelections;
var selectTests;
var selectApprover;

$(function() {
        var theDialog=$( "#openerform" ).dialog({
            autoOpen:false,
             height: 600,
                width: 600,
                title: 'Select Type of Change',
                //addModifyLots2 
                buttons: {
                    
                   
                    'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                        $(this).dialog('close');
                        }, 
                      'OK' : function () {
                        cancelAdd = 0;
                        //set value of id=typechangeselected to selected radio button
                        $("input[type='radio']:checked").each(function() {
                            var idVal = $(this).attr("id");
                           // alert($("label[for='"+idVal+"']").text());
                            $('#ChangeText').val($("label[for='"+idVal+"']").text().substring(0));
                            
                            $('#TypeChange').val($(this).attr("value"));
                            
                        });
                        
                        $(this).dialog('close');
                         }
              }
        
        
        });
        
  

        $("#opener").click(function(evt){
             theDialog.dialog('open');
             return false;
        });
        
        
        $("#ClearSearchEntries").click(function(evt){
               // alert("clear entries clicked");
             //theDialog.dialog('open');
             //return false;
        });
        //the Search button is on the Lots for STR dialog window and returns lots from Promis
         $("#Search").click(function(evt){
                //alert("search entries clicked");
                //call servlet to return Promis query results
                var partVal = $("#SearchPart").val();
                var processVal = $("#SearchProcess").val();
                 var obj = {
                add:[]
                 };
                //var pk22 = values["reticle"];
                //var pk33 = values["stock"];
                obj.add[obj.add.length] = {
                    part: partVal,
                    process: processVal
                  };
                //var obj = { part: partVal   };   
                //obj = $("#SearchPart").val();
                if (obj.length!==0) {
                    //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
                   $.ajax({ url:"/STRform_woutMaven/SearchPromis",
                    method: "POST",
                    data: JSON.stringify(obj) 
                }).done(function(msg) {
                    setTable(msg);
                });
            }
    
            
        });
        //the script below triggers a search when the enter key is hit inside the Part or Process search field
        $('#SearchPart').keypress(function (e) {
            var key = e.which;
            if(key === 13)  // the enter key code
             {
               $("#Search").click();
               return false;  
             }
           });   
            $('#SearchProcess').keypress(function (e) {
            var key = e.which;
            if(key === 13)  // the enter key code
             {
               $("#Search").click();
               return false;  
             }
           });   
    });


            var ajax = function(options) {
            var ret = {
                r: $.ajax(options),
                callback: null,
                done: function(callback) {
                    ret.r.done(function(msg, status, xhr) {

                            callback(msg, status, xhr);

                    });
                }
            };
            ret.r.fail(function(xhr, status, error) {
                $('#header_error_message').html(xhr.responseText);
                $('#header_error').dialog({
                    width: "auto",
                    minHeight: "0px",
                    resizable: false,
                    modal: true,
                    position:{ my: 'center', at: 'center', of: window }
                });
            });
            return ret;
        };
 (function() {

 addLotsToSTR = function() {
        //var lundo;

    };      
    
    typesRefresh = function() {
            configSetCallbacks(canSave, save, typesRefresh, typesAdd, typesRemove, addModifyLots, changeType);
            //ajax({url:"<%=path%>/secure/config/types/refreshtypes"}).done(function(msg) {
//            $.ajax({url:"/ImplantEdit/refreshtypes"}).done(function(msg) {
//                //console.log("ajax done with msg sending to setTable msg = " + msg);
//                setTable(msg);
//            });  
//            
//             $.ajax({url:"/ImplantEdit/refreshhistory"}).done(function(msg) {
//                //console.log("ajax done with msg sending to setTable msg = " + msg);
//                setHistory(msg);
//            });
//                ajax({url:"/ImplantEdit/refreshtypes"}).done(function(msg) {
//                    setTable(msg);
//                });
        };
   logout1 = function() {
    //console.log("configSetCallbacks.canSave() = " + configSetCallbacks.canSave() );
    
        //console.log("submitting ajax request to logout"  );
        
        $.ajax({ url: "/ImplantEdit/logout",
                method: "POST"
                //method: "GET"
                 });
            window.location ="http://jaz-cimdev2/ImplantEdit/index.jsp";
   
    };
     function canSave() {
         // alert("inside canSave function")
          return !$("#types_save").button("option", "disabled");
         //return !$("#types_save").button();
    };
       
     function save() {
      
        $( "#myForm" ).submit();

        if(cancelAdd !== 0){
            return;
        }
      
        
    };

 
     addModifyLots = function () {
          $( "#formAddLots" ).dialog({
                //height: 600,
              //width:'auto',
              //height:'auto',
            //  autoOpen:false,
            open: function() {
                // do something on load
                //alert("inside open function");
                lotsToSave.clear();
                for(i=1; i<counter; i++){
                    if( LotsForSTR[i - 1][0]  !== "" || LotsForSTR[i - 1][1]  !== "" || LotsForSTR[ i - 1][2]   !== "" ){
                             var lotsToSaveRow1 = lotsToSave.row.add( [ LotsForSTR[ i - 1][2] ,  LotsForSTR[i - 1][1]  , LotsForSTR[i - 1][0] ] );    
                     }
                     lotsToSave.draw(true);
                }
             },
             height: 600,
             width: 800,
             
                title: 'Search and Add Lots',
                //need to add lots to the lotsToSave dialog that are already in the STR
                //var lotsToSaveRow = lotsToSave.row.add( [ ids[i],  ids[i + 1] , ids[ i + 2] ] );    
                //addModifyLots2 
                buttons: {
 
                   'Add Selected Lots To This STR' : function () {
                       // cancelAdd = 1;
                       var table = lotsList;
                     //  $('#button').click(function (evt) {
                         var ids = $.map(table.rows('.selected').data(), function (item) {
                                    return item;
                        });
                        if(ids.length === 0 ){
                            alert("No Lots have been selected. Please select 1 or more Lots");
                        }
                        for(var i = 0; i <ids.length ; i += 3) {
                            
                            var $tds = $('#lotsToSave tr > td:nth-child(1)').filter(function () {
                                return $.trim($(this).text()) === ids[i];
                            });
                            if ($tds.length !== 0) {
                                alert("Lot " + ids[i] + " is already part of this STR");
                            } else {
                                var lotsToSaveRow = lotsToSave.row.add( [ ids[i],  ids[i + 1] , ids[ i + 2] ] );    
                            } 
                         }   
                  
                        lotsToSave.draw(true);

                        }, 
                     'Remove Designated Lots From This  STR' : function () {
                        var table = $('#lotsToSave').DataTable();
                          var removeLots = $.map(table.rows('.selected').data(), function (item) {
                                    return item;
                        });
                         if(removeLots.length === 0 ){
                            alert("No Lots have been selected to be removed. Please select 1 or more Lots");
                        } 
                         var rowsDeleted = table
                            .rows( '.selected' )
                            .remove()
                            .draw();
                            
                       
                        }, 
                        
                    'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                        lotsToSave.clear();
                        $(this).dialog('close');
                        }, 
                      'Save' : function () {
                            cancelAdd = 0;
                             //need to clear all content in table first 
                             //$("#STRtable4 > tbody").html("");
                            /// $("#tbodyid").empty()
                             $("#STRtable4").find("input,button,textarea,select").prop("disabled", false);
                            $('#STRtable4 tr').has('td').remove();
                            
                            var tableS = $('#lotsToSave');
 
                             var lot;
                             var port;
                             var process;
                             var vals = [];
                              var counter1=1;      
                            lotsToSave.cells().eq(0).each( function ( index ) {
                                var cell = lotsToSave.cell( index );
                                var data = cell.data();
                                vals.push(data);                                        
                            } );
                            //  $("#STRtable4").find('tbody').remove();
                            for(var kk = 0; kk < vals.length ; kk +=3) {
                                 lot =  vals[ kk ];
                                 port =   vals[ kk + 1 ];
                                 process =  vals[ kk + 2 ];
                               var  row1 = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceL' + counter1 + '" name="DeviceL' + counter1 + '" readonly value =' + port + '></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + counter1 + '" name="ProcessL' + counter1 + '" readonly value =' + process + '></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + counter1 + '" name="Lot_' + counter1 + '" readonly value =' + lot + '></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + '" type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM_' + counter1 + '" name="SCM_' + counter1 + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + counter1 + '" name="LotCony' + counter1 + '" >Yes</TD></tr>');
                                $("#STRtable4").find('tbody').append(row1);
                                counter1 = counter1 + 1;
                             }
                             //Below is needed to clear out any delete rows so the DB update also contain no values for any fields that are no longer used
                             for(var kk =  counter1; kk <= counter ; kk ++) {
                                var  row1 = $('<tr style="display:none;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceL' + kk + '" name="DeviceL' + kk + '" readonly value =' + "" + '></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + kk + '" name="ProcessL' + kk + '" readonly value =' + "" + '></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + kk + '" name="Lot_' + kk + '" readonly value =' + "" + '></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + '" type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM_' + kk + '" name="SCM_' + kk + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + kk + '" name="LotCony' + kk + '" >Yes</TD></tr>');
                                $("#STRtable4").find('tbody').append(row1);
                            }  
                            //DO NOT disable the rows once they are appended since they have to update the DB
                             $("#STRtable4").find("input,button,textarea,select").prop("readonly", true);
                             $(this).dialog('close');
                         }
              },
               resizeStop: function(event, ui) {
                    //alert("Width: " + $(this).outerWidth() + ", height: " + $(this).outerHeight());    
                    var heightOffset = 170;
                    var cHeight = $(this).height();
                    //alert(cHeight);
                    var dHeight = 0;
                    var oSettings = $('#lotList').dataTable().fnSettings();
                    oSettings.oScroll.sY = dHeight + "px";
                    $(".dataTables_scrollBody").height(cHeight - heightOffset);
                     var oSettings = $('#lotsToSave').dataTable().fnSettings();
                    oSettings.oScroll.sY = dHeight + "px";
                    $(".dataTables_scrollBody").height(cHeight - heightOffset);
                    
                 }
             
           }); 
       addModifyLots2();
    };
  addModifyLots2 = function () { 
 
    };      
 setupSelections = function () {
          $( "#setupSelect" ).dialog({
                //height: 600,
              //width:'auto',
              //height:'auto',
            //  autoOpen:false,
            open: function() {
                // do something on load
                //alert("inside open function");
               
             },
             height: 400,
                width: 500,
             
                title: 'Select Location and Applicable Areas',
                //need to add lots to the lotsToSave dialog that are already in the STR
                //var lotsToSaveRow = lotsToSave.row.add( [ ids[i],  ids[i + 1] , ids[ i + 2] ] );    
                //addModifyLots2 
                buttons: {
                  'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                       
                        $(this).dialog('close');
                        }, 
                      'Save' : function () {
                            cancelAdd = 0;
                            var selected = $('#location').find(':selected').text();
                              //var location = $('#location').val();
                              var primary = $('#primaryArea').find(':selected').text();
                              //var secondary = $('#secondaryArea').find(':selected').text();
                             $("#secondaryArea option:selected").each(function () {
                                    var $this = $(this);
                                    if ($this.length) {
                                        var selText = $this.text();
                                        if ( primary.indexOf(selText) === -1 ) {
                                            primary = primary + " " + selText;
                                       }
                                   }
                              });

                              $('#Area').val(primary );
                              $('#site').val(selected );
                             //alert(product);
                             $(this).dialog('close');
                         }
              },
               resizeStop: function(event, ui) {

                 }
             
           }); 
           
       //addModifyLots2();
    }; 
     selectTests = function () {
          $( "#selectRTest" ).dialog({
               
            open: function() {
              
             },
             height: 300,
              width: 300,
             
                title: 'Select Reliability Tests',
                //need to add lots to the lotsToSave dialog that are already in the STR
                //var lotsToSaveRow = lotsToSave.row.add( [ ids[i],  ids[i + 1] , ids[ i + 2] ] );    
                //addModifyLots2 
                buttons: {
                  'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                       
                        $(this).dialog('close');
                        }, 
                      'Save' : function () {
                            cancelAdd = 0;
                            var selected="";
                             $("#selectRL option:selected").each(function () {
                                    var $this = $(this);
                                    if ($this.length) {
                                        var selText = $this.text();
                                           selected = selected + " " + selText;
                                    }
                              });
                              
                              $("#ReliabilityTests").prop('disabled', false); 
                              $('#ReliabilityTests').val(selected );
                              $("#ReliabilityTests").prop('disabled', true); 
                             $(this).dialog('close');
                         }
              }
//               resizeStop: function(event, ui) {
//
//                 }
   }); 
           
       //addModifyLots2();
    }; 
    
       selectApprover = function () {
           //alert($('#AddtionalTesting').val());
           if( $('#AddtionalTesting').val() === "" ){
                $( "#formNeedSplits").dialog({
                    buttons: {
                  'Ok' : function () {
                            
                             $(this).dialog('close');
                         }
              }
            });
           }else {
           $( "#formApprovalGroup" ).dialog({
               
            open: function() {
                      var siteVal = $("#site").val().toString();
                      var areaVal = $("#Area").val().toString();
                      var statusVal = $("#Status").val().toString();
                       var obj = {
                      add:[]
                       };
                      
                      obj.add[obj.add.length] = {
                          site: siteVal,
                          area: areaVal,
                          status:statusVal
                        };
                      
                      if (obj.length!==0) {
                          
                         $.ajax({ url:"/STRform_woutMaven/GetApprovers",
                          method: "POST",
                          data: JSON.stringify(obj) 
                      }).done(function(msg) {
                        var json = JSON.parse(msg);
                     $('#selectApprover').children().remove().end();
                        $.each(json.approver, function(i, value) {
                                $('#selectApprover').append($('<option>').text(value).attr('value', value));
                            });

                      });
                  }
             },
             height: 300,
              width: 300,
              title: 'Select  approvers for email requests',
                
                buttons: {
                  'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                       
                        $(this).dialog('close');
                        }, 
                      'Ok' : function () {
                            cancelAdd = 0;
                            //var selected="";

                             $(this).dialog('close');
                         }
              }

         }); 
           
        }    //addModifyLots2();
    }; 
    //this wraps all elements in the page to jquery UI formats
   //wrapUIElements();
   //console.log("typesRefresh is being called");
   typesRefresh();
//  });      
})();
function configSetCallbacks(canSave, save, refresh, ins, del, addModifyLots , changeType) {
    //console.log("inside configSetCallbacks canSave = " +  canSave);
     //alert("inside configSetCallbacks");
    configSetCallbacks.canSave = canSave;
    
    configSetCallbacks.save = save;
    configSetCallbacks.refresh = refresh;
    configSetCallbacks.insert = ins;
    configSetCallbacks.delete = del;
    configSetCallbacks.addModifyLots = addModifyLots;
    configSetCallbacks.changeType = changeType;
}
function configRefresh() {
    if (configSetCallbacks.canSave()) {
        $('#config_refresh').dialog({
            width: 'auto',
            minHeight: '0px',
            resizable: false,
            modal: true,
            position:{ my: 'center', at: 'center', of: window }
        });
    } else {
        configSetCallbacks.refresh();
    }
}
function configSave() {
    //console.log("configSetCallbacks.canSave() = " + configSetCallbacks.canSave() );
    if (configSetCallbacks.canSave()) {
        $('#config_save').dialog({
            width: 'auto',
            minHeight: '0px',
            resizable: false,
            modal: true,
            position:{ my: 'center', at: 'center', of: window }
        });
    }
}
function configLogout() {
    //console.log("configSetCallbacks.canSave() = " + configSetCallbacks.canSave() );
    //if (configSetCallbacks.canSave()) {
        $('#config_logout').dialog({
            width: 'auto',
            minHeight: '0px',
            resizable: false,
            modal: true,
            position:{ my: 'center', at: 'center', of: window }
        });
    //}
} 
 
 
function setTable(msg) {
        var json = JSON.parse(msg);

        //$("#types_updated").html(json.updated);
        $("lotList th").css("width", "0px");
        //alert(msg);
        var table =  lotsList;
        table.clear();
        table.rows.add(json.types);
        table.column( '0' ).order( 'asc' );
//        var heightOffset = 200;
//        var cHeight = $('#formAddLots').height();
//        alert(cHeight);
//        var dHeight = 0;
//        var oSettings = $('#lotList').dataTable().fnSettings();
//        oSettings.oScroll.sY = dHeight + "px";
//        $(".dataTables_scrollBody").height(cHeight - heightOffset);
        table.draw();
       
        //editor.clear();
    }
    
     function setHistory(msg) {
        var json = JSON.parse(msg);

        $("#history_updated").html(json.updated);
        $("implant_history th").css("width", "0px");
       
        var table = historyTable;
        table.clear();
        table.rows.add(json.types);
        table.draw();
       
    }
  
    
            </script> 
 
 
    </body>

</html>

