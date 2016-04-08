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
  
    String generalStatus = null;
    
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
//            $(function() {
//              $( "#accordion" ).accordion({
//                  header: '.accordion-header',
//                  //resizing settings work for the width but not the height of the accordion
//                  //currently resizing is not in place
//                   //fillSpace: true , 
//                   // header: "h2",
//                     heightStyle: "fill",
//                    //heightStyle: "content",
//                   //event: "mouseover",
//                   activate: function (event, ui) { var cHeight = $('#container').height();
//                        var dHeight = 0;
//
//                    }
////                    changestart: function (event, ui) {
////                        ui.oldContent.accordion("activate", true);
////                    }
//
//              });
//           
//       });
//       $(function()  {
//            $('.accordion-expand-all a').click(function() { 
//            $('#accordion .ui-accordion-header:not(.ui-state-active)').next().slideToggle(); 
//            $(this).text($(this).text() === 'Expand all sections' ? 'Collapse lower Sections' : 'Expand all sections'); 
//            $(this).toggleClass('collapse'); return false; });
//
//        });
//   $(function() {
//    $( "#accordion-resizer" ).resizable({
//      minHeight: 100,
//      minWidth: 200,
//      resize: function() {
//        $( "#accordion" ).accordion( "refresh" );
//            //alert("inside accordion refresh");
//                        var cHeight = $('#container').height();
//                        var dHeight = 0;
//
//      }
//    });
//     });

$(function() {
    $( "#Date" ).datepicker();
  });
$(function() {
    $( "#FinalReportDate" ).datepicker();
  });
    $(function() {
      $(".LotGroup1").bind("change", function(){
            //alert("hi");
             if($('input:radio[name= LotGroup]:checked').val() > "1"){
                 var index = $('input:radio[name= LotGroup]:checked').val();
                 var index1 = ( $('input:radio[name= LotGroup]:checked').val() * 3 ) ;
                 var index2 = ( $('input:radio[name= LotGroup]:checked').val() * 4 ) ;
                  var text1 = $("#lotlist td:gt(" + index1 + ")" );
                 var text2 = $("#lotlist td:lt(" + index2 + ")" );
                $(text1).hide();
                 $(text2).show();      
                        //alert(index1 + " , " + text1);
             }else{
                  var index1 = ( $('input:radio[name= LotGroup]:checked').val() * 3 ) ;
                  var index2 = ( $('input:radio[name= LotGroup]:checked').val() * 4 ) ;
                  //var text1 =  "table td:gt(" + index1 + ")";
                 //var text2 =  "table td:lt(" + index2 + ")";
                 var text1 = $("#lotlist td:gt(" + index1 + ")" );
                 var text2 = $("#lotlist td:lt(" + index2 + ")" );
                 $(text1).hide();
                 $(text2).show();      
             }
         });
    });
       
  
  $(window).load(function() {
      //wrapUIElements();
      $("button").button();
     
      var counter=16;
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
                               ' <option value=25>25</option>'
    for(i=1; i<counter; i++){
         var row;
         var row2;
         var ScrWfrLa;
        var ScrWfrLSplit = new Array();
        var PCMDispositiona 
        switch(i) {
            case 1:
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL1")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL1")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_1")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '" >Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
                   row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL1")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select id= "DispositionL' + i + '" name="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_1")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip1")}"></TD><TD  style="width:100px">' + 
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '" class= "ScrWfrL' + i + '"  >' + 
                       scrWfrSelect + 
                       '</select></TD><TD> <textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL1")}</textarea></TD></tr>');
                        
                        $("#STRtable12").find('tbody').append(row2);
                        
                        PCMDispositiona = "${replys.get("DispositionL1")}";
                        $("#DispositionL1").val(PCMDispositiona);
                         ScrWfrLa = "${replys.get("ScrWfrL1")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL1").val(ScrWfrLSplit);
                       
                         if("${replys.get("LotCon_1")}" === "Yes" ){
                            $("#LotCony1").prop("checked", true);
                         };
                         var Scm1 = "${replys.get("SCM_1")}";
                        $("#SCM1").val(Scm1);
                 break;
            case 2:
                if( "${replys.get("DeviceL2" )}"  !== "" || "${replys.get("ProcessL2" )}" !== "" || "${replys.get("Lot_2" )}"  !== "" ){
                      row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL2")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL2")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_2")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                        $("#STRtable4").find('tbody').append(row);
                }
               if("${replys.get("QADispL2")}"  !== "" || "${replys.get("PLD_2")}" !== "" || "${replys.get("PEMgrOKSHip2")}"  !== "" || "${replys.get("CommentDispL2")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL2")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect + 
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_2")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip2")}"></TD><TD  style="width:100px">' + 
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  +
                        '<TD><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4 >${replys.get("CommentDispL2")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL2")}";
                        $("#DispositionL2").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL2")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL2").val(ScrWfrLSplit);
                          if("${replys.get("LotCon_2")}" === "Yes" ){
                            $("#LotCony2").prop("checked", true);
                         };
      
                         
               }
               break;
             case 3:
                 if( "${replys.get("DeviceL3" )}"  !== ""|| "${replys.get("ProcessL3" )}"  !=="" || "${replys.get("Lot_3" )}"  !== "" ){
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value "${replys.get("DeviceL3")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL3")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_3")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
             }
             if("${replys.get("QADispL3")}"  !== "" || "${replys.get("PLD_3")}" !== "" || "${replys.get("PEMgrOKSHip3")}"  !== "" || "${replys.get("CommentDispL3")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL3")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                                shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_3")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip3")}"></TD><TD  style="width:100px">' +
                         '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  +
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4 >${replys.get("CommentDispL3")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL3")}";
                        $("#DispositionL3").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL3")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL3").val(ScrWfrLSplit);
               }
                 break;
            case 4: 
                 if( "${replys.get("DeviceL4" )}"  !== "" || "${replys.get("ProcessL4" )}"  !=="" || "${replys.get("Lot_4" )}"  !== "" ){
               row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL4")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL4")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_4")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                $("#STRtable4").find('tbody').append(row);
            }
             if("${replys.get("QADispL4")}"  !== "" || "${replys.get("PLD_4")}" !== "" || "${replys.get("PEMgrOKSHip4")}"  !== "" || "${replys.get("CommentDispL4")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL4")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + 
                            ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                                shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_4")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip4")}"></TD><TD  style="width:100px">' +
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  +
                        + '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL4")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL4")}";
                        $("#DispositionL4").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL4")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL4").val(ScrWfrLSplit);
               }
                break;
            case 5:
                 if( "${replys.get("DeviceL5" )}"  !== "" || "${replys.get("ProcessL5" )}"  !== ""  || "${replys.get("Lot_5" )}"   !== "" ){
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL5")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL5")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_5")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
             }
              if("${replys.get("QADispL5")}"  !== "" || "${replys.get("PLD_5")}" !== "" || "${replys.get("PEMgrOKSHip5")}"  !== "" || "${replys.get("CommentDispL5")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL5")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_5")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip5")}"></TD><TD  style="width:100px">' +
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  +
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL5")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL5")}";
                        $("#DispositionL5").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL5")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL5").val(ScrWfrLSplit);
               }
                break;
           case 6:  
                if( "${replys.get("DeviceL6" )}"  !== "" || "${replys.get("ProcessL6" )}"   !== "" || "${replys.get("Lot_6" )}"   !== ""  ){
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL6")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL6")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_6")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
             }
             if("${replys.get("QADispL6")}"  !== "" || "${replys.get("PLD_6")}" !== "" || "${replys.get("PEMgrOKSHip6")}"  !== "" || "${replys.get("CommentDispL6")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL6")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_6")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip6")}"></TD><TD  style="width:100px">' +
                         '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
            '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL6")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL6")}";
                        $("#DispositionL6").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL6")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL6").val(ScrWfrLSplit);
               }
                 break;
            case 7:
                 if( "${replys.get("DeviceL7" )}"   !== ""  || "${replys.get("ProcessL7" )}"   !== ""  || "${replys.get("Lot_7" )}"   !== ""  ){
               row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL7")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL7")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_7")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                $("#STRtable4").find('tbody').append(row);
            }
             if("${replys.get("QADispL7")}"  !== "" || "${replys.get("PLD_7")}" !== "" || "${replys.get("PEMgrOKSHip7")}"  !== "" || "${replys.get("CommentDispL7")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL7")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_7")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip7")}"></TD><TD  style="width:100px">' +
                         '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL7")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL7")}";
                        $("#DispositionL7").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL7")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL7").val(ScrWfrLSplit);
               }
                break;
            case 8:
                  if( "${replys.get("DeviceL8" )}"   !== "" || "${replys.get("ProcessL8" )}"   !== ""  || "${replys.get("Lot_8" )}"   !== ""  ){
               row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL8")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL8")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_8")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                $("#STRtable4").find('tbody').append(row);
            }
            if("${replys.get("QADispL8")}"  !== "" || "${replys.get("PLD_8")}" !== "" || "${replys.get("PEMgrOKSHip8")}"  !== "" || "${replys.get("CommentDispL8")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL8")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_8")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip8")}"></TD><TD  style="width:100px">' +
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL8")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL8")}";
                        $("#DispositionL8").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL8")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL8").val(ScrWfrLSplit);
               }
                break;
           case 9:
               if( "${replys.get("DeviceL9" )}"  !== ""   || "${replys.get("ProcessL9" )}"   !== ""  || "${replys.get("Lot_9" )}"   !== ""  ){
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL9")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL9")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_9")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
             }
              if("${replys.get("QADispL9")}"  !== "" || "${replys.get("PLD_9")}" !== "" || "${replys.get("PEMgrOKSHip9")}"  !== "" || "${replys.get("CommentDispL9")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL9")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_9")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip9")}"></TD><TD  style="width:100px">' + 
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL9")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL9")}";
                        $("#DispositionL9").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL9")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL9").val(ScrWfrLSplit);
               }
                 break;
            case 10: 
                if( "${replys.get("DeviceL10" )}"   !== "" || "${replys.get("ProcessL10" )}"   !== ""   || "${replys.get("Lot_10" )}" !== ""  ){
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL10")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL10")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_10")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
             }
             if("${replys.get("QADispL10")}"  !== "" || "${replys.get("PLD_10")}" !== "" || "${replys.get("PEMgrOKSHip10")}"  !== "" || "${replys.get("CommentDispL10")}" !== "" ){ 
                    row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL10")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_10")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip10")}"></TD><TD  style="width:100px">' +
                         '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL10")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                         PCMDispositiona = "${replys.get("DispositionL10")}";
                        $("#DispositionL10").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL10")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL10").val(ScrWfrLSplit);
               }
                 break;
             case 11:
                 if( "${replys.get("DeviceL11" )}"   !== ""  || "${replys.get("ProcessL11" )}"   !== ""  || "${replys.get("Lot_11" )}"  !== ""  ){
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value "${replys.get("DeviceL11")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL11")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_11")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
             }
             if("${replys.get("QADispL11")}"  !== "" || "${replys.get("PLD_11")}" !== "" || "${replys.get("PEMgrOKSHip11")}"  !== "" || "${replys.get("CommentDispL11")}" !== "" ){ 
             row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL11")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                                shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_11")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip11")}"></TD><TD  style="width:100px">' +
                       '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL11")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL11")}";
                        $("#DispositionL11").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL11")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL11").val(ScrWfrLSplit);
               }
                 break;
            case 12:  
                 if( "${replys.get("DeviceL12" )}"  !== ""  || "${replys.get("ProcessL12" )}"  !== "" || "${replys.get("Lot_12" )}"  !== ""  ){
               row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL12")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL12")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_12")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                $("#STRtable4").find('tbody').append(row);
            }
             if("${replys.get("QADispL12")}"  !== "" || "${replys.get("PLD_12")}" !== "" || "${replys.get("PEMgrOKSHip12")}"  !== "" || "${replys.get("CommentDispL12")}" !== "" ){ 
             row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL12")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_12")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip12")}"></TD><TD  style="width:100px">' +
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL12")}</textarea>></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL12")}";
                        $("#DispositionL12").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL12")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL12").val(ScrWfrLSplit);
               }
                break;
            case 13:
                 if( "${replys.get("DeviceL13" )}"   !== ""  || "${replys.get("ProcessL13" )}"  !== "" || "${replys.get("Lot_13" )}"   !== ""  ){
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL13")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL13")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_13")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
             }
             if("${replys.get("QADispL13")}"  !== "" || "${replys.get("PLD_13")}" !== "" || "${replys.get("PEMgrOKSHip13")}"  !== "" || "${replys.get("CommentDispL13")}" !== "" ){ 
             row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL13")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                                shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_13")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip13")}"></TD><TD  style="width:100px">' +
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        ' <TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL13")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL13")}";
                        $("#DispositionL13").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL13")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL13").val(ScrWfrLSplit);
               }
                 break;
           case 14:  
                if( "${replys.get("DeviceL14" )}"   !== ""  || "${replys.get("ProcessL14" )}"   !== ""  || "${replys.get("Lot_14" )}"  !== ""  ){
                row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL14")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL14")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_14")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                 $("#STRtable4").find('tbody').append(row);
             }
              if("${replys.get("QADispL14")}"  !== "" || "${replys.get("PLD_14")}" !== "" || "${replys.get("PEMgrOKSHip14")}"  !== "" || "${replys.get("CommentDispL14")}" !== "" ){ 
             row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL14")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                                shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_14")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip14")}"></TD><TD  style="width:100px">' +
                        '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL14")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL14")}";
                        $("#DispositionL14").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL14")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL14").val(ScrWfrLSplit);
               }
                 break;
            case 15:
                 if( "${replys.get("DeviceL15" )}"   !== "" || "${replys.get("ProcessL15" )}"  !== ""  || "${replys.get("Lot_15" )}"  !== ""  ){
               row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL15")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL15")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_15")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                $("#STRtable4").find('tbody').append(row);
            }
             if("${replys.get("QADispL15")}"  !== "" || "${replys.get("PLD_15")}" !== "" || "${replys.get("PEMgrOKSHip15")}"  !== "" || "${replys.get("CommentDispL15")}" !== "" ){ 
             row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL15")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_15")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip15")}"></TD><TD  style="width:100px">' +
                         '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL15")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL15")}";
                        $("#DispositionL15").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL15")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL15").val(ScrWfrLSplit);
               }
                break;
            case 16:
                 if( "${replys.get("DeviceL16" )}"   !== ""  || "${replys.get("ProcessL16" )}"  !== ""  || "${replys.get("Lot_16" )}"   !== ""  ){
               row = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceFullPath' + i + '" name="DeviceFullPath' + i + '" readonly value ="${replys.get("DeviceL16")}"></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + i + '" name="ProcessL' + i + '" readonly value ="${replys.get("ProcessL16")}"></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + i + '" name="Lot' + i + '" readonly value ="${replys.get("Lot_16")}"></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + ' type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM' + i + '" name="SCM' + i + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + i + '" name="LotCony' + i + '">Yes</TD></tr>');
                $("#STRtable4").find('tbody').append(row);
            }
             if("${replys.get("QADispL16")}"  !== "" || "${replys.get("PLD_16")}" !== "" || "${replys.get("PEMgrOKSHip16")}"  !== "" || "${replys.get("CommentDispL16")}" !== "" ){ 
             row2 = $('<tr style="display:table-row;"><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="QADispL' + i + '" name="QADispL' + i + '" readonly value ="${replys.get("QADispL16")}"></TD ><TD  style="width:100px">' + '<input type="checkbox" id="Prob' + i + ' name="Prob' + i + '">Yes</TD><TD  style="width:100px">' + ' <select name="DispositionL' + i + '" id="DispositionL' + i + '">' +       
                                shipselect +
                        '</select></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="PLD' + i + '" name="PLD' + i + '" readonly value ="${replys.get("PLD_16")}"></TD><TD  style="width:100px"><input style="width:100%;" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '" readonly value ="${replys.get("PEMgrOKSHip16")}"></TD><TD  style="width:100px">' +
                       '<select multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '">' + 
                       scrWfrSelect + '</select></TD>'  + 
                        '<TD style="width:130px"><textarea  id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >${replys.get("CommentDispL16")}</textarea></TD></tr>');
       
                        $("#STRtable12").find('tbody').append(row2);
                        PCMDispositiona = "${replys.get("DispositionL16")}";
                        $("#DispositionL16").val(PCMDispositiona);
                        ScrWfrLa = "${replys.get("ScrWfrL16")}";
                        ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                        $("#ScrWfrL16").val(ScrWfrLSplit);
               }
                break;     
             default:
        }
       
    }  
     
    for(i=1; i<=counter; i++){
         row2 = $('<tr> ><TD>' + i + '</td><td><input type="text" id="DEVICE FULL PARTNAME' + i + '" name="DEVICE FULL PARTNAME" value=" "></td><td id="process' + i + '" name="process">' + ' <select>' +       
                         '<option value="XAA" >XAA </option>'   +    
                        '<option value="BC35M" >BC35M </option>'   +    
                        '<option value="BC35MF" >BC35MF </option>'   +    
                        '</select></TD><td id="LOT ID' + i + '" name="LOT ID">'+ ' <select>' + 
                        '<option value="Existing Lot" >Existing Lot</option>'   +    
                        '<option value="New Lot Only" >New Lot Only </option></select></td></tr>');
                $("#lotlist").find('tbody').append(row2);
    }
 
 

 });
  </script>
  
    </head>
    <body id="dt_example" >
       
        <div>
<!--         <button onclick="this.blur();typesRefresh();" title="Refresh All Tables.">Refresh</button> -->
         <button id="types_save" onclick="this.blur();configSave();"  title="Save As Draft." >Save As Draft</button> 
         <button id="str_print" onclick="this.blur();"  title="Print STR.">Print</button> 
         <button id="str_modifyLots" onclick="this.blur();configSetCallbacks.addModifyLots();addModifyLots();"  title="Modify Lots." >Add/Modify Lots</button>
         <button id="str_approve" onclick="this.blur();"  title="Approve." >Approve</button>
         <button id="str_reject" onclick="this.blur();"  title="Reject." >Reject</button>
         <button id="str_delete" onclick="this.blur();"  title="Delete." >Delete</button>
         <button id="str_SCMPC_changeLots" onclick="this.blur();addModifyLots();"  title="SCM/PC Change Lots." >SCM/PC Change Lots</button>
         <button id="str_duplicate" onclick="this.blur();"  title="Duplicate STR." >Duplicate STR</button>
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
             <button type="submit" >Submit</button>  
              
<!--             <form class= "STRform" id="STRform" action="#"  >    -->
            <div id="container">
                <div><b>${mongodb}</b></div>
<!--                <i class="str-info">Click on a entry to change.</i><i class="str-updated">(Last Refresh: <span id="str_updated">Never</span>)</i>-->
                <TABLE class= "STRtable"id="STRtable1" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD style="width:90px" bgcolor="lightgray">STR No:</TD>
<!--             "SZMW012516037733"-->
<!--                    \${fn:escapeXml(param.STRNumber)}-->
                     <td style="width:475px"><input style="display:table-cell; width:100%;" type="text" id="_id" name="_id" readonly value ="${replys.get("_id")}"  ></td>
                
                     <TD style="width:70px" bgcolor="lightgray">Status:</TD>
                     <TD  style="width:200px" ><input style="display:table-cell; width:100%; color: red;" type="text" id="Status" name="Status" readonly value ="${replys.get("Status")}"></TD>
                    </TR>
                </TABLE>
                 <br>
                 <TABLE class= "STRtable" id="STRtable2" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <TR>
                     <TD style="width:90px" bgcolor="lightgray">STR Title:</TD>
                     <TD style="width:770px" colspan="3"><input name="STR_TITLE" id="STR_TITLE"    type='text' style="display:table-cell; width:100%;"   value="${replys.get("STR_TITLE")}"  ></TD>
                    </TR>
<!--                    alert(${replys.get("STR_TITLE")});-->
                    <TR>
                     <TD style="width:90px" bgcolor="lightgray">Engineer:</TD>
                    <TD style="width:450px" ><input  name="Engineer" id="Engineer" style="display:table-cell; width:100%;" type='text' value="${replys.get("Engineer")}" ></TD>
                    <TD style="width:70px" bgcolor="lightgray">Sign-Off Date:</TD>
                    <TD style="width:200px" ><input name="Date" id="Date" type="text" style="display:table-cell; width:100%;"  value="${replys.get("Date")}"></TD>
                     </TR>
                    <TR>
                     <TD style="width:90px"  bgcolor="lightgray">Extension:</TD>
                    <TD style="width:450px" ><input  name="Ext" id="Ext" style="display:table-cell; width:100%;" type='text' value="${replys.get("Ext")}"/></TD>
                    <TD style="width:70px" bgcolor="lightgray">Area:</TD>
                    <TD style="width:200px" ><input style="display:table-cell; width:100%;" type="text" id="Area" name="Area" readonly value ="${replys.get("Area")}" ></TD>
                    </TR>
                    <TR>
                     <TD style="width:90px"  bgcolor="lightgray">Dept:</TD>
                    <TD style="width:450px" ><input  id="Dept" name="Dept" readonly style="display:table-cell; width:100%;" type='text' value="${replys.get("Dept")}"/></TD>
                    <TD style="width:70px" bgcolor="lightgray">Final Report Date:</TD>
                    <TD style="width:200px" ><input style="display:table-cell; width:100%;" name="FinalReportDate" id="FinalReportDate" type="text" value="${replys.get("Final_Report_Date")}" ></TD>
                    </TR>
                     <TR>
                    <TD style="width:90px" bgcolor="lightgray">Type of Change:</TD>
                    <TD style="width:720px" colspan="3" ><button id="opener" class="opener" type="button" >Type Change</button><input style="border: 0px solid #000000;" name="TypeChange" id="TypeChange" type="text" value= "${replys.get("TypeChange")}" > <textarea  id="ChangeText"  name="ChangeText"  style="border: none"  ROWS=3  >${replys.get("ChangeText")}</textarea></TD>
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
                    <TD  style="width:720px"  colspan="3"  ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text'id="Abstract" name="Abstract"  value= "${replys.get("Abstract")}" /></TD>
                    </TR>
                </TABLE>                    
<!--                
<!--                
                 <textarea  id="strnum" style="display:none;"  ></textarea>
                    <br> 
<!--                    <div>-->
           
                   
   <!--         <form name="myForm" id="myForm" method="post"  >
            <p>Text: <input name="text" type="text" value="<
   %= request.getParameter("text")!=null ? request.getParameter("text") : "" %>"></p>
            <p>Rich Text: <div name="richtext"  contenteditable="true" style="width: 400px;height: 100px;overflow: auto;border: 1px solid black"><
   %= newRichText %></div></p>
            <button type="submit" >Submit</button>
        </form>  --->
  
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
                    <TD style="width:200px" ><input id="Shippable" name="Shippable" style="display:table-cell; width:100%;" type='text'value= "${replys.get("Shippable")}"></TD>
                     </TR>
                    <TR>
                    <TD style="width:90px" bgcolor="lightgray">Reliability Required:</TD>
                    <TD style="width:470px" > <input type="radio" id="ReliabilityRequired" name="ReliabilityRequired" value= "${replys.get("ReliabilityRequired")}">Yes<input type="radio" id="ReliabilityRequired1" id="ReliabilityRequired1" value= "${replys.get("ReliabilityRequired_1")}">No</TD>
                    <TD style="width:90px" bgcolor="lightgray">Select Reliability Tests That Are Required:</TD>
                    <TD style="width:200px" ><input id="ReliabilityTests" name="ReliabilityTests" style="display:table-cell; width:100%;" type='text' value= "${replys.get("ReliabilityTests")}" readonly="true"></TD>
                    </TR>
                    <TR>
                    <TD style="width:90px" bgcolor="lightgray">Number of splits (2 Days/split):</TD>
                    <TD style="width:470px"  ><input  id="AddtionalTesting" name="AddtionalTesting" style="display:table-cell; width:100%;" type="text"  value= "${replys.get("AdditionalTesting")}"></TD> 
                    <TD style="width:90px" bgcolor="lightgray">Comment:</TD>
                    <TD style="width:200px"  ><input  id="AddtionalTestComment" name="AddtionalTestComment" style="display:table-cell; width:100%;" type='text' value= "${replys.get("AddtionalTestComment")}"></TD>
                    </TR>
                     <TR>
                    <TD style="width:90px" bgcolor="lightgray">Lots Converted to Proper Lot Type:</TD>
                    <TD style="width:760px" colspan="3"  ><input  id="LotTypeConv" name="LotTypeConv" style="display:table-cell; width:100%;" type='text' value= "${replys.get("LotTypeConv")}"><input  id="LotTypeConvDate" name="LotTypeConvDate" style="width:100%; padding-left:0px; padding-right:0px;" type='text' value= "${replys.get("LotTypeConvDate")}" readonly="true"></TD>
                    </TR>
                </TABLE>
               <br>
                 <TABLE class= "STRtable" id="STRtable4" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <th colspan="6" >LOTS DESIGNATED FOR STR</th>
                     <TR>
                     <th style="width:140px" bgcolor="lightgray">Device Full Pathname</th>
                    <th  style="width:110px"bgcolor="lightgray">Process</th>
                    <th  style="width:110px"bgcolor="lightgray">Lot No.</th>
                    <th  style="width:120px"bgcolor="lightgray" >SCM/PC Approval</th>
                     <th  style="width:220px"bgcolor="lightgray">Approver</th>
                     <th  style="width:140px" bgcolor="lightgray">Lot Converted to Proper Lot Type</th>
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
            <% 
                TreeMap<Integer, String> attachments = new TreeMap<>();
                int attachmentCounter = 0;
                List<String> arrayList1 = new ArrayList<>();
                arrayList1.add(request.getParameter("richtext"));
                arrayList1.add(request.getParameter("richtext2"));
                arrayList1.add(request.getParameter("richtext3"));
          //      int i = 0;
         //       while (i < arrayList1.size()) {
               String richText =arrayList1.get(0);
           //             i++;
               //String richText =arrayList1.get(0);
                
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
                        //String sep = ",";
                        //attachmentCounter = 0;
                        attachments.put(attachmentCounter ,   fileName + " ==> " + fileBody);

                        //Rewrite the link
                        newText.append("<a href=\"");
                        newText.append(attachmentCounter++);
                        newText.append("\">");
                    }
                    newText.append(richText.substring(prevIndx));
                    newRichText = newText.toString();
                }
              //}   
                
            %>
            
<!--    <p>Text: <input name="text" type="text" value="<
%=request.getParameter("text")!=null ? request.getParameter("text") : "" %>"></p> --->
<p><b>STR Instructions: </b><div class="strinstructions" id="STR_INSTRUCTION" name="richtext"  contenteditable="true" style="width: 870px;height: 100px;overflow: auto;border: 1px solid black" >${replys.get("STR_INSTRUCTION")}</div></p>
          
 <ul>
         <% 
            for (Map.Entry<Integer, String> entry : attachments.entrySet()) {
                out.print("<li>");
                out.print(entry.getKey());
                out.print(" ==> ");
                String fileBody = entry.getValue();
                out.println(fileBody.length()<=512 ? fileBody : fileBody.substring(0, 512) + "...[" + NumberFormat.getInstance().format(fileBody.length()-512) + " more bytes]");
                out.println("</li>");
                
            }
            Gson gson = new Gson(); 
            String json1 = gson.toJson(attachments); 
        %>
           </ul> 
          <br>
            <p><b>Success Criteria:</b></p>
            <TABLE class= "STRtable" id="STRtable6" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:870px" >What is the success criteria (null and alternative hypothesis) STR results must meet to move to the next stage</th>
                      <TR>
                          <TD  > <textarea  style="border: none"  name="criteria" id="criteria" ROWS=1 >${replys.get("STR_successcriteria")}</textarea></TD>
                      </TR>
            </table> 
           <br>
          <p><b>Success Plan:</b></p>
            <TABLE class= "STRtable" id="STRtable7" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:870px" >If successful what is the next phase?</th>
                      <TR >
                          <TD > <textarea  style="border: none"  ROWS=1 name="trplan" id="trplan" >${replys.get("STR_successplan")}</textarea></TD>
                      </TR>
            </table>   
            <br>
            <p><b>Approver Groups:</b></p>
             <TABLE class= "STRtable" id="STRtable8" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                 <TR>
                 <th style="width:130px" bgcolor="lightgray">Approver Groups:</th>
                <th  style="width:470px"bgcolor="lightgray">Approvers:</th>
                <th  style="width:100px"bgcolor="lightgray">Action:</th>
                <th  style="width:150px"bgcolor="lightgray" >Date:</th>
                 </TR>
                 <TR>
                 <TD style="width:130px"><input  id="Group1" name="Group1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group1")}' readonly="true"></TD>    
                 <TD  style="width:470px"><input  id="Who1" name="Who1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who1")}' readonly="true"></TD>
                 <TD  style="width:100px"><input  id="ActionTaken1" name="ActionTaken1" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken1")}' readonly="true"></TD>    
                  <TD  style="width:150px"><input  id="ActionDate1" name="ActionDate1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate1")}' readonly="true"></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group2" name="Group2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group2")}' readonly="true"></TD>    
                 <TD i style="width:470px"><input  id="Who2" name="Who2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who2")}' readonly="true"></TD>
                 <TD  style="width:100px"><input  id="ActionTaken2" name="ActionTaken2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken2")}' readonly="true"></TD>    
                  <TD  style="width:150px"><input  id="ActionDate2" name="ActionDate2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate2")}' readonly="true"></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group3" name="Group3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group3")}' readonly="true"></TD>    
                 <TD i style="width:470px"><input  id="Who3" name="Who3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who3")}' readonly="true"></TD>
                 <TD  style="width:100px"><input  id="ActionTaken3" name="ActionTaken3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken3")}' readonly="true"></TD>    
                  <TD  style="width:150px"><input  id="ActionDate3" name="ActionDate3"  style="display:table-cell; width:100%;"type='text'value='${replys.get("ActionDate3")}' readonly="true"></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group4" name="Group4"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group4")}' readonly="true"></TD>    
                <TD i style="width:470px"><input  id="Who4" name="Who4"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who4")}' readonly="true"></TD>
                 <TD  style="width:100px"><input  id="ActionTaken4" name="ActionTaken4"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionTaken4")}' readonly="true"></TD>    
                  <TD  style="width:150px"><input  id="ActionDate4" name="ActionDate4"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionDate4")}' readonly="true"></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group5" name="Group5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group5")}' readonly="true"></TD>    
                 <TD i style="width:470px"><input  id="Who5" name="Who5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who5")}' readonly="true"></TD>
                 <TD  style="width:100px"><input  id="ActionTaken5" name="ActionTaken5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken5")}' readonly="true"></TD>    
                  <TD  style="width:150px"><input  id="ActionDate5" name="ActionDate5"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionDate5")}' readonly="true"></TD>    
                 </TR>
                 <TR>
                 <TD style="width:130px"><input  id="Group6" name="Group6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group6")}' readonly="true"></TD>    
                <TD i style="width:470px"><input  id="Who6" name="Who6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who6")}'  readonly="true"></TD>
                 <TD  style="width:100px"><input  id="ActionTaken6" name="ActionTaken6"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionTaken6")}' readonly="true"></TD>    
                  <TD  style="width:150px"><input  id="ActionDate6" name="ActionDate6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate6")}' readonly="true"></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group7" name="Group7"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group7")}' readonly="true"></TD>    
                 <TD i style="width:470px"><input  id="Who7" name="Who7"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who7")}' readonly="true"></TD>
                 <TD  style="width:100px"><input  id="ActionTaken7" name="ActionTaken7" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken7")}' readonly="true"></TD>    
                  <TD  style="width:150px"><input  id="ActionDate7" name="ActionDate7" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate7")}' readonly="true"></TD>    
                 </TR>
           </TABLE>
          <br>
             <p id="rejectioncomments"><b>Rejection Comments:</b></p>
            <TABLE class= "STRtable"id="STRtable9" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD  style="width:870px" ><textarea  style="border: none"  id="ApprovalComments" name="ApprovalComments" ROWS=1 >${replys.get("ApprovalComments")}</textarea></TD>
                    </TR>
                </TABLE>
           <br> 
           <p ><b>SCM/PC Approval Record:</b></p>
            <p><div id="SCMRecord" class="strinstructions" name="richtext"  contenteditable="true" style="width: 670px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("SCMRecord")}</div></p>
           <br>
            <p id="lotchangerecord"><b>Lot Change Record:</b></p>
            <TABLE class= "STRtable"id="STRtable10" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD style="width:100px" bgcolor="lightgray">Change Request Comments:</TD>
                     <TD style="width:770px" ><textarea  style="border: none"  ROWS=1  id="ChangeRequestComment"  name="ChangeRequestComment">${replys.get("ChangeRequestComment")}</textarea></TD>
                     </TR>
                     <TR>
                     <TD style="width:100px" bgcolor="lightgray">Lot Change Comments:</TD>
                     <TD style="width:770px" ><textarea  style="border: none"  ROWS=1 id="LotChangeComment" name="LotChangeComment" >${replys.get("LotChangeComment")}</textarea></TD>
                    </TR>
                </TABLE>
            <br>
           <p id="strreportattachment"><b>STR Report Attachment:</b></p>
            <p id="strreportattachment2">Attach STR Report.</p>
           <p><div id="Attachments" name="richtext"  class="strinstructions" contenteditable="true" style="width: 670px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("Attachments")}</div></p>
           <br>
          <p id="poststrattachment"><b>Post Completion Comments:</b></p>
            <p id="poststrattachment2">Comments to be added after a STR has completed.</p>
           <p><div id="PostCompletionComments" name="richtext" class="strinstructions" contenteditable="true" style="width: 870px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("PostCompletionComments")}</div></p>            
            
           <br>
            <p id="strdisposition"><b>STR Disposition:</b></p> 
            <p id="strdisposition2" ><Font COLOR=RED  >->Reliability Test Burn In Boards:</Font></p> 
            <TABLE class= "STRtable1" id="STRtable11a" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
            <TR>
            <TD style="width:100px"  bgcolor="lightgray">Reliability Test Required?</TD>
            <TD  style="width:100px" ><input type="radio" name="RelTestReqDispY" id="RelTestReqDispY"  >Yes<input type="radio" name="RelTestReqDispN" id="RelTestReqDispN">No</TD>
            <TD style="width:50px" bgcolor="lightgray">Rel:</TD>
            <TD  style="width:300px" ><input id="RelTestMgr" name="RelTestMgr"  style="display:table-cell; width:100%;" type='text' value='${replys.get("RelTestRelMgr")}' readonly="true"></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input id="RelTestDate" name="RelTestDate"  style="display:table-cell; width:100%;" type='text' value='${replys.get("RelTestDate")}' readonly="true"></TD>
             </TR>
             <TR>
            <TD style="width:100px"  bgcolor="lightgray">Reliability Tests:</TD>
            <TD  colspan="5" style="width:630px" ><input id="RelTests" name="RelTests" style="display:table-cell; width:100%;" type='text' value='${replys.get("RelTestsList")}' readonly="true"></TD>
             </TR>
              <TR>
            <TD style="width:100px"  bgcolor="lightgray">Rel Manager Comment About Reliability Tests:</TD>
            <TD  colspan="5" style="width:630px" ><input id="Rel1Comment" name="Rel1Comment"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Rel1Comment")}' readonly="true"></TD>
             </TR>
            </table>
            <p>Attach Reliability Report:<div id="Attachments_1" name="richtext"  contenteditable="true" style="width: 670px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("Attachments_1")}</div></p>   
            <TABLE class= "STRtable1" id="STRtable11b" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
            <TR>
            <TD style="width:100px"  bgcolor="lightgray">For Delivery to Customer</TD>
            <TD  style="width:100px" ><input type="radio" id="CustDeliveryY" name="CustDeliveryY">Yes<input type="radio" id="CustDeliveryN" id="CustDeliveryN">No</TD>
            <TD style="width:50px" bgcolor="lightgray">QA:</TD>
            <TD style="width:300px" ><input  id="CustDelQAMgr"  name="CustDelQAMgr"  style="display:table-cell; width:100%;" type='text' value='${replys.get("CustDelQAMgr")}' readonly="true"></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input  id="CustDelDate"  name="CustDelDate"  style="display:table-cell; width:100%;" type='text' value='${replys.get("CustDelDate")}' readonly="true"></TD>
             </TR>
             <TR>
            <TD style="width:100px"  bgcolor="lightgray">Final Release to Production</TD>
            <TD  style="width:80px" ><input type="radio" id="RelToProductionY" name="RelToProductionY">Yes<input type="radio"id="RelToProductionN" name="RelToProductionN">No</TD>
            <TD style="width:50px" bgcolor="lightgray">QA:</TD>
            <TD  style="width:300px" ><input id="RelProdQAMgr"  name="RelProdQAMgr"  style="display:table-cell; width:100%;" type='text' value='${replys.get("RelProdQAMgr")}' readonly="true"></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input  id="RelProdDate"   name="RelProdDate"  style="display:table-cell; width:100%;" type='text' value='${replys.get("RelProdDate")}' readonly="true"></TD>
             </TR>
             <TR>
            <TD style="width:200px" colspan="2"  bgcolor="lightgray">QA Manager Comment About Deliverable Lots:</TD>
            <TD colspan="4" style="width:530px" ><textarea  style="border: none"  id="QA1Comment" name="QA1Comment" ROWS=1 >${replys.get("QA1Comment")}</textarea></TD>
             </TR>
              <TR>
            <TD style="width:200px"  colspan="2" bgcolor="lightgray">QA Manager Comment About Final Release to Prod</TD>
            <TD  colspan="5" style="width:530px" <textarea  style="border: none"  id="QA2Comment" name="QA2Comment" ROWS=1 >${replys.get("QA2Comment")}</textarea></TD>
             </TR>
            </table>
            <br>
            <div class="table12">
             <TABLE class= "STRtable1" id="STRtable12" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
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
            <TABLE class= "STRtable13" id="STRtable13" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                <TR >
                     <th style="width:100px" bgcolor="lightgray">STR-REL Submit Date</th>
                     <th style="width:100px" bgcolor="lightgray">QA Response Date:</th>
                     <th style="width:550px" bgcolor="lightgray">QA Response Comments:</th>
                     </TR>
<!--                     <TR >
                         <TD id="STRSubDate" style="width:100px" ></TD>
                         <TD id="QAFeedbackDate1" style="width:100px" ></TD>
                         <TD id="QAFeedback1" style="width:550px" ></TD>
                      </TR>-->
            </table>
             <br>
            <p  class="revisionhistory"><b>Revision History:</b></p> 
            <TABLE class= "STRtable1" id="STRtable14" BORDER="0" CELLPADDING="2" CELLSPACING="2" >
                <tr>
                <TD  style="width:750px" ><textarea  readonly="true" style="border: none"  ROWS=5 id="UpdatedBy" name="UpdatedBy" >'${replys.get("Revisions")}'</textarea></TD>    
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
           
   <form class= "LotGroup1" id="formAddLots" action="#" title="Add Lots"  style="display:none" >
                 <fieldset class="radiogroup">
                 <legend>How many lots are required?</legend> 
                  <p>
                 <input type="hidden" id="id" name="id" value="-1"  />
                 <input type="radio" id="radio1" name="LotGroup" value="1" checked="true"/><label for="radio1">1</label>
                 <input type="radio" id="radio2" name="LotGroup" value="2" /><label for="radio2">2</label>
                 <input type="radio" id="radio3" name="LotGroup" value="3" /><label for="radio3">3</label>
                 <input type="radio" id="radio4" name="LotGroup" value="4" /><label for="radio4">4</label>
                 <input type="radio" id="radio5" name="LotGroup" value="5" /><label for="radio5">5</label>
                 <input type="radio" id="radio6" name="LotGroup" value="6" /><label for="radio6">6</label>
                 <input type="radio" id="radio7" name="LotGroup" value="7" /><label for="radio7">7</label>
                 <input type="radio" id="radio8" name="LotGroup" value="8" /><label for="radio8">8</label>
                 <input type="radio" id="radio9" name="LotGroup" value="9" /><label for="radio9">9</label>
                 <input type="radio" id="radio10" name="LotGroup" value="10" /><label for="radio10">10</label>
                 <input type="radio" id="radio11" name="LotGroup" value="11" /><label for="radio11">11</label>
                 <input type="radio" id="radio12" name="LotGroup" value="12" /><label for="radio12">12</label>
                 <input type="radio" id="radio13" name="LotGroup" value="13" /><label for="radio13">13</label>
                 <input type="radio" id="radio14" name="LotGroup" value="14" /><label for="radio14">14</label>
                 <input type="radio" id="radio15" name="LotGroup" value="15" /><label for="radio15">15</label>
                 <input type="radio" id="radio16" name="LotGroup" value="16" /><label for="radio16">16</label>
                 <input type="radio" id="radio17" name="LotGroup" value="17" /><label for="radio17">17</label>
                 <input type="radio" id="radio18" name="LotGroup" value="18" /><label for="radio18">18</label>
                 <input type="radio" id="radio19" name="LotGroup" value="19" /><label for="radio19">19</label>
                 <input type="radio" id="radio20" name="LotGroup" value="20" /><label for="radio20">20</label>
                 <input type="radio" id="radio21" name="LotGroup" value="21" /><label for="radio21">21</label>
                  </p>
                </fieldset>
                 <p style="color:red">Please type one device, lot, process per row</p>
                 
                  <table id="lotlist" class="lotlist"   >
                    <thead>
                        <tr>
                            <th>LOT</th>
                            <th>DEVICE FULL PARTNAME</th>
                            <th>PROCESS</th>
                            <th>LOT ID</th>
                             
                        </tr>
                    </thead>
                    
                    <tbody>

            </tbody>
                </table>
                 

          </form>
            <div id="openerform" class="openerform" title="Select Type of Change">
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
        </div>
      </div>  
   
            <script>
 //var typesTable;
 var lotsTable;
 //var historyTable;
 var tr ;
 var clickedRow;
 var option;
 var clickedRowHistory; 
 var nextRowAdd=0;
 var cancelAdd = 0;
 var heightOffset = 115;
 var editorTest;
    $(document).ready(function () {
        
       if("${replys.get("RelTestReqDisp")}" === "YES" ){
        $("#RelTestReqDispY").prop("checked", true);
       };
       if("${replys.get("RelTestReqDisp")}" === "NO" ){
        $("#RelTestReqDispN").prop("checked", true);
      };
       if("${replys.get("CustDelivery")}" === "YES" ){
        $("#CustDeliveryY").prop("checked", true);
       };
       if("${replys.get("CustDelivery")}" === "NO" ){
        $("#CustDeliveryN").prop("checked", true);
      };
       if("${replys.get("RelToProduction")}" === "YES" ){
        $("#RelToProductionY").prop("checked", true);
       };
       if("${replys.get("RelToProduction")}" === "NO" ){
        $("#RelToProductionN").prop("checked", true);
      };
      
         //$("#RelToProductionY").prop("checked", true);
        // $("#radio_1").attr('checked', 'checked');
//    var wysiwygeditor = wysiwyg( option );
//    wysiwygeditor.setHTML( '<html>' );

    //  $.bookAuthors = ScrWfrL1.split("   ");
    // $("#ScrWfrL1").val( $.bookAuthors );            
 });       

var typesRefresh;
var typesAdd;
var typesCopy;
var changeType;
var addModifyLots;
var typesRemove;
var select1;
var historyRemove;



$(function() {
        var theDialog=$( "#openerform" ).dialog({
            autoOpen:false,
        height: 600,
                width: 500,
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
                            $('#ChangeText').val($("label[for='"+idVal+"']").text().substring(1));
                            
                            $('#TypeChange').val($(this).attr("value"));
                        });
                        //var label = $('input[type="radio"]:checked').parent().next().find('label').text();
                         //var val = $("#openerform input[type='radio']:checked").val();
                        
                        //var selectedrd = $("input:radio[name ='radiogroup']:checked").text();
                        //alert(label);
                        
                        $(this).dialog('close');
                         }
              }
        
        
        });

        $("#opener").click(function(evt){
             theDialog.dialog('open');
             return false;
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
//     select1 = function() {
//         $("#extraupload").uploadFile({
//            url:"/STRform_woutMaven/strsave",
//            fileName:"myfile",
//            uploadStr:"Select Files",
//           // dragDrop:false,
//            dragDropStr: "<span>Drag and Drop</span>",
// //           dragDropWidth: 100,
////            extraHTML:function()
////            {
////                    var html = "<div><b>File Tags:</b><input type='text' name='tags' value='' /> <br/>";
////                            html += "</div>";
////                            return html;    		
////            },
//  
//            autoSubmit:false
//               });
//            $("#extrabutton").click(function()
//            {
//                $(this).find('[contenteditable]').each(function(i,e) {
//                    e=$(e);
//                    e.next('textarea').val(e.html());
//                     alert('textarea').val(e.html());
//                });
//                extraObj.startUpload();
//        }); 
//     };
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
       // var loguser = "";
       //alert("inside save function");
       //var strno = $("#str_main  i.str-info input.STRno").val();
          
//       $(this).find('[contenteditable]').each(function(i,e) {
//                    e=$(e);
//                    e.next('textarea').val(e.html());
//                    alert("inside html placement script");
//                });
        $( "#myForm" ).submit();
//        var strno = $('input.STRno').val();
//        var strno1 = strno.toString();
//        var strno2 = strno1.substring(8);
//        var str = $('textarea.STRtitle').val();
        //var editor1 = $('#richtext').html();
        
       //alert(editor1);
       //parse the editor1 string for the file tag
       //editor1.text().toString().;
       //var p1 = editor1.indexOf(">");
      // var p2 = editor1.lastIndexOf("</a>");
       
       //var name1 = editor1.substr(p1 + 1 , p2 - (p1 + 1) );
       //alert(editor1);
        if(cancelAdd !== 0){
            return;
        }
      
        //var obj = { _id: strno2 ,  strnum: strno,  strtitle: str , STRdoc0: "<
                //%=  attachments %>"  //strObj1 : editor1 
                             
         //    };
         // var obj = { unid: strno2   };   
//              obj.STRdoc0[obj.STRdoc0.length] = {
//                        0: "<
        //%=  attachments.get(0) %>"  
//
//         };
          //obj.STRdoc0[0] =  <
                  //%=  json1 %>  ;    
            // alert(STRdoc);
        // changing array elements with java driver for mongo is tricky so I am avoiding them for now
       
                ////{
//                        strobj0: strobj1,
//                        strobj1: str
//
//         };
        
//         if (obj.length!==0) {
//                //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
//                // $.ajax({ url:"/STRform_woutMaven/openlotusnotes",
//                $.ajax({ url:"/STRform_woutMaven/newclass",
//                method: "POST",
//                data: JSON.stringify(obj) 
//            }).done(function(msg) {
//             //   setTable(msg);
//            });
//        }
        //add a second ajax url for servlet to GridFS with json objects of embedded docs
//         if (obj.length!==0) {
//                //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
//                $.ajax({ url:"/STRform_woutMaven/strsave",
//                method: "POST",
//                data: JSON.stringify(obj) 
//            }).done(function(msg) {
//             //   setTable(msg);
//            });
 //       }
    };
//    (function ($) {
//         $( ".openerform" ).dialog({
//             autoOpen: false,
//                height: 600,
//                width: 500,
//                title: 'Select Type of Change',
//                //addModifyLots2 
//                buttons: {
//                    'Cancel' : function () {
//                        cancelAdd = 1;
//                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
//                        $(this).dialog('close');
//                        }, 
//                      'Save' : function () {
//                        cancelAdd = 0;
//                        $(this).dialog('close');
//                         }
//              }
//           }); 
//           // Dialog Link
//    $('.opener').click(function(e){
//        e.preventDefault();
//        var cells = $(this).parent().find('td');
//        //$('#mod_monbre').val(cells.eq(0).text());
//        //$('#mod_codigo').val(cells.eq(1).text());
//        //$('#mod_modo').val(cells.eq(2).text());
//        $('.openerform').dialog('open');
//        return false;
//    });
//       //addModifyLots2();
//    });
 
     addModifyLots = function () {
         $( "#formAddLots" ).dialog({
                height: 600,
                width: 500,
                title: 'Add Lots',
                //addModifyLots2 
                buttons: {
                    'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                        $(this).dialog('close');
                        }, 
                      'Save' : function () {
                        cancelAdd = 0;
                        $(this).dialog('close');
                         }
              }
           }); 
       addModifyLots2();
    };
  addModifyLots2 = function () { 
         var text1 = "#lotlist td:gt(" + 3 + ")";
         $(text1).hide();
        
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

        $("#types_updated").html(json.updated);
        $("implant_main th").css("width", "0px");
        
        var table = typesTable;
        table.clear();
        table.rows.add(json.types);
        table.column( '0' ).order( 'asc' );
        table.draw();
       
        editor.clear();
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

