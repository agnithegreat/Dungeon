package assets {
	import flash.display.Bitmap;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import flash.utils.Dictionary;
	
	/**
	 * @author desktop
	 */
	public class Assets {
		
		private static var gameTextures: Dictionary = new Dictionary();
		
		private static var fireTextureAtlas: TextureAtlas;
		
		[Embed(source="../assets/textures/fire.png")]
		private static const FireTextureAltas : Class;
		
		[Embed(source="../assets/textures/fire.xml", mimeType="application/octet-stream")]
		private static const FireAltasXML : Class;
		
		public static function getAtlas():TextureAtlas {
			if (!fireTextureAtlas) {
				var texture: Texture = getTexture("FireTextureAltas");
				var xml: XML = XML(new FireAltasXML());
				fireTextureAtlas = new TextureAtlas(texture, xml);
			}
			return fireTextureAtlas;
		}
		
		public static function getTexture($name: String):Texture {
			if (!gameTextures[$name]) {
				var bitmap: Bitmap = new Assets[$name]();
				gameTextures[$name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[$name];
		}
	}
}
