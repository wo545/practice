
var Range={
	from:1,
	to:5
}
Object.defineProperties(Range,{
	'include':{
		value:function(x){return x>this.from&&x<this.to},
		writable:false,
		enumerable:false,
		configurable:true
	}
});