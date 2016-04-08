<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.Map.Entry"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.TreeMap,java.util.Map,java.text.NumberFormat"%>
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
  </style>
        <script>
            $(function() {
              $( "#accordion" ).accordion({
                  header: '.accordion-header',
                  //resizing settings work for the width but not the height of the accordion
                  //currently resizing is not in place
                   //fillSpace: true , 
                   // header: "h2",
                     heightStyle: "fill",
                    //heightStyle: "content",
                   //event: "mouseover",
                   activate: function (event, ui) { var cHeight = $('#container').height();
                        var dHeight = 0;

                    }
//                    changestart: function (event, ui) {
//                        ui.oldContent.accordion("activate", true);
//                    }

              });
           
       });
       $(function()  {
            $('.accordion-expand-all a').click(function() { 
            $('#accordion .ui-accordion-header:not(.ui-state-active)').next().slideToggle(); 
            $(this).text($(this).text() === 'Expand all sections' ? 'Collapse lower Sections' : 'Expand all sections'); 
            $(this).toggleClass('collapse'); return false; });

        });
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
      var counter=(24);
    for(i=0; i<counter; i++){
        var row = $('<tr class="trclass' + i + '" style="display:none;"  ><TD class="tdclass' + i + '" style="width:100px">' + 'text'+ i + '</TD><TD style="width:100px">' + 'text'+ i + '</TD><TD style="width:100px">' + 'text'+ i + '</TD><TD style="width:100px">' + 'text'+ i + '</TD><TD style="width:130px">' + 'text'+ i + '</TD><TD style="width:100px">' + 'checkbox'+ i + '</TD></tr>');
        //$("#STRtable4").after(row.html());
        $("#STRtable4").find('tbody').append(row);
       
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
            <p class="accordion-expand-all"><b><a href="#">Expand all sections</a></b></p>
           <h3 class="accordion-header">Main STR Section </h3> 
            <!-- The template to display files available for upload -->
           <form name="myForm" id="myForm" method="post"  >
<!--             <form class= "STRform" id="STRform" action="#"  >    -->
            <div id="container">
                <i class="str-info">Click on a entry to change.</i><i class="str-updated">(Last Refresh: <span id="str_updated">Never</span>)</i>
               
                <TABLE class= "STRtable1"id="STRtable1" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD style="width:90px" bgcolor="lightgray">STR No:</TD>
                     <TD style="width:415px" class="STRno">SZMW012516037733</TD>
                     <TD style="width:70px" bgcolor="lightgray">Status:</TD>
                     <TD style="width:70px" class="status"><FONT COLOR=RED  > Draft</FONT></TD>
                    </TR>
                </TABLE>
                <br>
                <br>
                 <TABLE class= "STRtable2" id="STRtable2" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <TR>
                     <TD style="width:90px" bgcolor="lightgray">STR Title:</TD>
                     <TD style="width:570px" colspan="3" class="STRtitle"><input style="width:100%; padding-left:0px; padding-right:0px;"  type='text' value='STR Test'/></TD>
                    </TR>
                    <TR>
                     <TD style="width:90px" bgcolor="lightgray">Engineer:</TD>
                    <TD style="width:400px" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='m.whitney'/></TD>
                    <TD style="width:70px" bgcolor="lightgray">Sign-Off Date:</TD>
                    <TD style="width:50px" >calendar input here</TD>
                     </TR>
                    <TR>
                     <TD style="width:90px"  bgcolor="lightgray">Extension:</TD>
                    <TD style="width:400px" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='Ext'/></TD>
                    <TD style="width:70px" bgcolor="lightgray">Area:</TD>
                    <TD style="width:50px" >Area</TD>
                    </TR>
                     <TR>
                    <TD style="width:90px" bgcolor="lightgray">Type of Change:</TD>
                    <TD style="width:520px" colspan="3" class="typeOfChange" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='Button - Selected Type of Change'/></TD>
                    </TR>
                   <TR>
                    
                    <TD style="width:90px" bgcolor="lightgray">Tool Qualification Selection:</TD>
                    <TD style="width:520px"  colspan="3" class="toolselection" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='dropdown of tools'/></TD>
                    </TR>
                   <TR>
                   
                    <TD style="width:90px" bgcolor="lightgray">Abstract:</TD>
                    <TD  style="width:520px"  colspan="3" class="abstract" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='abstract'/></TD>
                    </TR>
                </TABLE>
                    
<!--                <TD class="STRno"> <textarea  style="border: none" contenteditable="false" ROWS=1 >SZMW012516037733</textarea></TD>-->
<!--                copy div into textarea on submit and then ajax the textarea into the webservlet-->
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
          <p>Lots Designated for STR:</p>
<!--              <i class="table-info">  </i> <i class="table-updated"> (Last Refresh: <span id="history_updated">Never</span>)</i>-->
             <TABLE class= "STRtable3" id="STRtable3" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <TR>
                    
                     <TD style="width:110px"  bgcolor="lightgray">Total Lots Requested:</TD>
                    <TD style="width:380px" >?</TD>
                    <TD style="width:90px" bgcolor="lightgray">Are Lots Shippable?:</TD>
                    <TD style="width:50px" >?</TD>
                     </TR>
                    <TR>
                    <TD style="width:110px" bgcolor="lightgray">Reliability Required:</TD>
                    <TD style="width:380px" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='Ext'/></TD>
                    <TD style="width:90px" bgcolor="lightgray">Select Reliability Tests That Are Required:</TD>
                    <TD style="width:50px" >Reliability Tests:</TD>
                    </TR>
                    <TR>
                    <TD style="width:110px" bgcolor="lightgray">Number of splits (2 Days/split):</TD>
                    <TD style="width:380px" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='Additional Testing # & Disp'/></TD>
                    <TD style="width:90px" bgcolor="lightgray">Comment:</TD>
                    <TD style="width:50px" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='Additional Comment'/></TD>
                    </TR>
                     <TR>
                    <TD style="width:110px" bgcolor="lightgray">Lots Converted to Proper Lot Type:</TD>
                    <TD style="width:520px" colspan="3" class="abstract" ><input  style="width:100%; padding-left:0px; padding-right:0px;" type='text' value=''/></TD>
                    </TR>
                </TABLE>
                <br>
                <br>
                 <TABLE class= "STRtable4" id="STRtable4" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <th colspan="6" >LOTS DESIGNATED FOR STR</th>
                     <TR>
                     <th style="width:100px" bgcolor="lightgray">Device Full Pathname</th>
                    <th  style="width:100px"bgcolor="lightgray">Process</th>
                    <th  style="width:100px"bgcolor="lightgray">Lot No.</th>
                    <th  style="width:100px"bgcolor="lightgray" >SCM/PC Approval</th>
                     <th  style="width:130px"bgcolor="lightgray">Approver</th>
                     <th  style="width:100px" bgcolor="lightgray">Lot Converted to Proper Lot Type</th>
                       </TR>
                </TABLE>
            <br>
            <br>
             <p>Purpose of STR:</p>
            <TABLE class= "STRtable5" id="STRtable5" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:670px" >Type the purpose, including the benefits and risks, for this STR inside this box.</th>
                      <TR class="trpurpose" id="trpurpose">
                          <TD class="tdpurpose" > <textarea  style="border: none"  ROWS=1 ></textarea></TD>
                      </TR>
            </table>
            <br>
           <br>
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
                
            %>
            
            <p>Text: <input name="text" type="text" value="<%=request.getParameter("text")!=null ? request.getParameter("text") : "" %>"></p>
            <p>STR Instructions: <div name="richtext"  contenteditable="true" style="width: 400px;height: 100px;overflow: auto;border: 1px solid black"><%= newRichText %></div></p>
            <button type="submit" >Submit</button>
      
            
                  <script>
            //Add textarea (must be textarea to allow large files) after all contenteditable fields to receive HTML during submission
            
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
                    //store these in a json array for submitting
                   e.next('textarea').val(e.html());
                   
                   
                });
                $.ajax({ url:"/STRform_woutMaven/newclass",
                        method: "POST",
                        data: JSON.stringify(e) 
                    }).done(function(msg) {
             //   setTable(msg);
                    });
            });
        </script>
        
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
                   
                <tr>
                <td>1</td>
                <td><input type="text" id="DEVICE FULL PARTNAME" name="DEVICE FULL PARTNAME" value=" "></td>
<!--                <td><input type="text" id="PROCESS" name="PROCESS" value="PROCESS"></td>-->
                <td><select size="1" id="PROCESS" name="PROCESS">
                    <option value="XAA" selected="selected">
                        XAA
                    </option>
                    <option value="BC35M">
                        BC35M
                    </option>
                    <option value="BC35MF">
                        BC35MF
                    </option>
                    <option value="BC35MP">
                        BC35MP
                    </option>
                    <option value="BC35MPB">
                        BC35MPB
                    </option>
                </select></td>
<!--                <td><input type="text" id="LOT ID" name="LOT ID" value="LOT ID"></td>-->
                <td><select size="1" id="LOT ID" name="LOT ID">
                    <option value="Existing Lot" >
                        Existing Lot
                    </option>
                    <option value="New Lot Only">
                        New Lot Only
                    </option>
                    </select></td></tr>
                <tr>
                <td>2</td>
                <td><input type="text" id="DEVICE FULL PARTNAME" name="DEVICE FULL PARTNAME" value=" " ></td>
<!--                <td><input type="text" id="PROCESS" name="PROCESS" value="PROCESS"></td>-->
                <td><select size="1" id="PROCESS" name="PROCESS">
                    <option value="XAA" selected="selected">
                        XAA
                    </option>
                    <option value="BC35M">
                        BC35M
                    </option>
                    <option value="BC35MF">
                        BC35MF
                    </option>
                    <option value="BC35MP">
                        BC35MP
                    </option>
                    <option value="BC35MPB">
                        BC35MPB
                    </option>
                </select></td>
<!--                <td><input type="text" id="LOT ID" name="LOT ID" value="LOT ID"></td>-->
                <td><select size="1" id="LOT ID" name="LOT ID">
                    <option value="Existing Lot" >
                        Existing Lot
                    </option>
                    <option value="New Lot Only">
                        New Lot Only
                    </option>
                     </select></td>
            </tr>
            <tr>
                <td>3</td>
                <td><input type="text" id="DEVICE FULL PARTNAME" name="DEVICE FULL PARTNAME" value=" " ></td>
<!--                <td><input type="text" id="PROCESS" name="PROCESS" value="PROCESS"></td>-->
                <td><select size="1" id="PROCESS" name="PROCESS">
                    <option value="XAA" selected="selected">
                        XAA
                    </option>
                    <option value="BC35M">
                        BC35M
                    </option>
                    <option value="BC35MF">
                        BC35MF
                    </option>
                    <option value="BC35MP">
                        BC35MP
                    </option>
                    <option value="BC35MPB">
                        BC35MPB
                    </option>
                </select></td>
<!--                <td><input type="text" id="LOT ID" name="LOT ID" value="LOT ID"></td>-->
                <td><select size="1" id="LOT ID" name="LOT ID">
                    <option value="Existing Lot" >
                        Existing Lot
                    </option>
                    <option value="New Lot Only">
                        New Lot Only
                    </option>
                     </select></td>
            </tr>
            </tbody>
                </table>
                 
<!--                <label for="name">Reason For Change:</label><TEXTAREA NAME="comments" COLS=50 ROWS=10 id="comments" ></TEXTAREA> 
                <br />
               <label for="name">Revision Number</label><input type="text" name="revision" id="revision"/>
                <br />-->

          </form>
        
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

//    var wysiwygeditor = wysiwyg( option );
//    wysiwygeditor.setHTML( '<html>' );
 });       

var typesRefresh;
var typesAdd;
var typesCopy;

var addModifyLots;
var typesRemove;
var select1;
var historyRemove;
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
            configSetCallbacks(canSave, save, typesRefresh, typesAdd, typesRemove, addModifyLots);
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
        var strno = $('input.STRno').val();
        var strno1 = strno.toString();
        var strno2 = strno1.substring(8);
        var str = $('textarea.STRtitle').val();
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
          var obj = { unid: strno2   };   
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
        
         if (obj.length!==0) {
                //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
                // $.ajax({ url:"/STRform_woutMaven/openlotusnotes",
                $.ajax({ url:"/STRform_woutMaven/newclass",
                method: "POST",
                data: JSON.stringify(obj) 
            }).done(function(msg) {
             //   setTable(msg);
            });
        }
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
function configSetCallbacks(canSave, save, refresh, ins, del, addModifyLots) {
    //console.log("inside configSetCallbacks canSave = " +  canSave);
     //alert("inside configSetCallbacks");
    configSetCallbacks.canSave = canSave;
    
    configSetCallbacks.save = save;
    configSetCallbacks.refresh = refresh;
    configSetCallbacks.insert = ins;
    configSetCallbacks.delete = del;
    configSetCallbacks.addModifyLots = addModifyLots;
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

