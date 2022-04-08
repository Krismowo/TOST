sleeptake = 2;
if(self.inventory.contains("jacket")){
	self.gotoroom("Outside_Cabin_jacket");
}else{
	self.gotoroom("Outside_Cabin_nojacket");
}