package com.myjavapapers.blogspot.mycollections;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;

public class CompareTwoLists {
	
	public static void main(String[] args) {
		
		CompareTwoLists compareTwoLists = new CompareTwoLists();
		List<String> ceoETAEventEquipmentsList = compareTwoLists.getceoETAEventEquipmentsList();
		List<String> tihEquipmentsList = compareTwoLists.getTIHEquipmentsList();
		Collection intersection = CollectionUtils.intersection(ceoETAEventEquipmentsList, tihEquipmentsList);
		//ceoETAEventEquipmentsList.removeAll(tihEquipmentsList);
		
		System.out.println(intersection);
		
	}

	public List<String> getceoETAEventEquipmentsList(){
		String[] ceoETAEventEquipmentsArray = {"DCLX2018","ACFX77341","DCLX2042","DOWX8513","PROX33623","PROX34093","PROX30088","PROX29835","CGTX64442","PROX32296","PROX30068","PROX32159","PROX30142","PROX32198","PROX31246","PROX31849","PROX33214","PROX32142","SRIX33948","PROX34098","PROX32303","PROX34238","ACFX73508","GATX201243","SHPX221910","GATX200118","SHPX221915","ACFX73508","TILX401580","PROX32302","PROX32920","UTLX930114","UTLX930114","PROX28063","TILX401585","TILX601180","PROX34815","PROX34284","PROX34217","PROX33639","PROX33271","PROX33662","PROX33638","PROX33277","CGTX64397","PROX33661","PROX33212","PROX32346","PROX30004","PROX33331","PROX34123","PROX30224","PROX30002","PROX30073","PROX34251","PROX32245","OLNX711034","SBLX14039","UTLX900240","SBLX14085","SHPX240330","SBLX14021","SHPX240330","OLNX711034","SBLX14039","UTLX900240","SBLX14085","SBLX14021","PROX31792","AXLX1857","TILX400722","TILX303148","UTLX954305","UTLX954308","DBCX9996","AXLX1857","DOWX88130","CCBX7078","CCBX7136","SBLX14021","SBLX14039","SBLX14085","UTLX900240","UTLX82603","CGTX64379","ACFX94847","UTLX900879","DCLX1026","UTLX910083","ACFX77342","UTLX901286","UTLX901292","ACFX77333","CCBX7049","CCBX7052","CCBX7128","RAIX2559","DOWX88127","DOWX88099","CCBX7147","AXLX1857","SHPX240171","DOWX88105","SHPX240171","SHPX240171","SHPX240171","TILX303159","TILX303152","TILX303178","TILX400718","SRIX33819","GATX201364","SHPX221948","GATX201202","GATX200120","PROX28110","OLNX114035","OLNX113008","SHPX240459","SHPX240455","OLNX711015","TILX600645","TILX600841","TILX400872","TILX600657","TILX601225","TILX600504","TILX600783","DUPX18031","TILX600424","ACFX73508","UTLX802854","UTLX920152","SHPX221948","SRIX33819","GATX201202","GATX200120","GATX201364","CGTX64442","PROX29835","PROX30088","PROX31246","PROX32142","PROX31849","PROX30142","PROX30068","GATX200120","GATX201202","GATX201364","SHPX221948","SRIX33819","AXLX1857","TILX601180","UTLX902666","UTLX930117","UTLX902670","UTLX902842","UTLX902666","UTLX930117","UTLX902670","UTLX902842","UTLX920180","OLNX116020","ACFX240028","SBLX14045","OLNX117014","OLNX116135","UTLX903391","UTLX954699","SHPX240316","UTLX902666","UTLX930117","UTLX902670","UTLX902842","DOWX88105","CCBX7078","DOWX88130","CCBX7136","UTLX950035","TILX401150","TILX401166","TILX401152","TILX401162","TILX401183","UTLX920085","GATX202612","GATX202568","TILX500750","TILX500747","TILX500865","TILX500998","TILX500919","TILX500870","TILX500942","TILX500881","TILX500805","TILX601180","ACFX73502","TILX600224","TILX600234","ACFX73525","TILX600230","SRIX33819","GATX201364","SHPX221948","GATX201202","GATX200120","SFLX23034","UTLX954699","UTLX903391","PROX33624","PROX34124","PROX34112","PROX34075","GATX201194","SRIX33832","TIMX201222","DUPX25050","DUPX25034","TILX501041","TILX500976","TILX500798","TILX501031","TILX500821","TILX501007","TILX501041","TILX500976","TILX500798","TILX501031","TILX500821","TILX501007","UTLX920085","SHPX240140","HOKX132649","HOKX7814","HOKX132570","HOKX132852","HOKX132555","HOKX132550","HOKX7962","HOKX132912","HOKX8455","UTLX920251","SRIX33821","GATX200039","GATX200044","GATX201437","SRIX33772","PROX32325","SBLX14156","SBLX14156","SHPX240140","HOKX132649","HOKX7814","HOKX132570","HOKX132852","HOKX7962","HOKX132555","HOKX132550","HOKX132912","HOKX8455","TILX401580","HOKX8455","HOKX132912","HOKX132550","HOKX132555","HOKX132852","HOKX132570","HOKX7814","HOKX132649","SHPX240140","HOKX7962","TILX303874","TILX303874","SFLX23034"};
		return Arrays.asList(ceoETAEventEquipmentsArray);
	}
	
	public List<String> getTIHEquipmentsList(){
		String[] tihETAEquipmentsArray = {"AXLX001381","TILX601062","AXLX001857","UTLX920303","OPIX000406","SBLX015019","DUPX018042","HOKX007750","TILX600952","TILX600782","DOWX088075","DOWX088129","DOWX088128","CCBX007058","DOWX088126","CCBX007070","CCBX007125","CCBX007067","CCBX007057","UTLX902843","OPIX000406","SBLX015019","DUPX018042","HOKX007750","UTLX082603","CGTX064379","UTLX027453","SRIX017026","SHPX240171"};
		return Arrays.asList(tihETAEquipmentsArray);
		
	}
}
