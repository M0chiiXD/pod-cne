var glitch = new CustomShader("glitching");
glitch.SPEED = 0;
glitch.AMT = 0;
var iTime:Float = 0;
function create()
{
    camHUD.addShader(glitch);
    camGame.addShader(glitch);

    eye = new FlxSprite(0, 0);
    eye.frames = Paths.getSparrowAtlas("stages/idkthissong/eyes");
    eye.animation.addByPrefix("eyes close", "eyes close", 4, true);
    eye.animation.addByPrefix("eyes look", "eyes look", 8, true);
    eye.animation.addByPrefix("eyes open", "eyes open", 4, true);
    eye.animation.play("eyes close");
    eye.visible = false;
}

function update(elapsed:Float)
{
    iTime += elapsed;
    glitch.iTime = iTime;
}


function stepHit(step:Int) {
    switch (step) { 
        case 760:
            FlxTween.num(0, 1, 3, {ease: FlxEase.quadIn}, (val:Float) -> { glitch.AMT = val; });
            FlxTween.num(0, 0.3, 3, {ease: FlxEase.quadIn}, (val:Float) -> { glitch.SPEED = val; });
        case 800:
            stage.getSprite("sprite_3").visible = false;
            glitch.SPEED = 0;
            glitch.AMT = 0;
        case 820:
            eye.visible = true;
            eye.animation.play("eyes open");
    }
}