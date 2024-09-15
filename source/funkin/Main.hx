package funkin;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState, 240, 240));

		var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0xffffff);

		addChild(fps_mem);
	}
}
