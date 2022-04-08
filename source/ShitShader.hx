package;
import flixel.system.FlxAssets.FlxShader;
/**
 * ...
 * @author KittyNya
 */
class ShitShader extends FlxShader 
{
	#if !html5
	@:glFragmentSource('
	#pragma header
	const float scale = 1;
	uniform int iTime;
	void main() {
		vec3 col = texture2D(bitmap, openfl_TextureCoordv).rgb;
		vec2 shit = openfl_TextureCoordv;
		if (iTime % 3 == 0.0){
			if(iTime % 8 == 0.0){
				shit.x = openfl_TextureCoordv.x;
				shit.x += 0.0035;
				
			}
			vec3 col = texture2D(bitmap, shit).rgb;
			if(iTime % 8 == 0.0){
				col.r -= 0.012;
				col.g -= 0.012;
				col.b -= 0.012;
			}
			gl_FragColor = vec4(col.r, col.g, col.b, 0.95); //edited thing here
		}else{
			shit.x = openfl_TextureCoordv.x;
			shit.x -= 0.001;
			gl_FragColor = texture2D(bitmap, shit); 
		}
	}')
	#else
	@:glFragmentSource('
	#pragma header
	const int scale = 1;
	bool movlef = false;
	uniform int iTime;
	void main(){
		vec3 col = texture2D(bitmap, openfl_TextureCoordv).rgb;
		vec2 shit = openfl_TextureCoordv;
		if (iTime == 0){
			if(movlef){
				shit.x = openfl_TextureCoordv.x;
				shit.x += 0.0035;
				
			}
			vec3 col = texture2D(bitmap, shit).rgb;
			if(movlef){
				col.r -= 0.012;
				col.g -= 0.012;
				col.b -= 0.012;
			}
			gl_FragColor = vec4(col.r, col.g, col.b, 0.95); //edited thing here
			if(movlef == false){
				movlef = true;
			}
		}else{
			shit.x = openfl_TextureCoordv.x;
			shit.x -= 0.001;
			gl_FragColor = texture2D(bitmap, shit); 
		}
	}')
	#end
	public function new() 
	{
		super();
	}
	
}