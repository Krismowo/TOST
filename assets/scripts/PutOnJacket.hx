sleeptake = 1;
if(!self.inventory.contains("jacket")){
	self.gotoroom("Get_Jacket");
	self.inventory.push("jacket");
	
}else{
	self.gotoroom("Got_Jacket");
}