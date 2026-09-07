
var randomcard:Bool = false;

public var card:FlxSprite;


public var mechanicCard1:FlxSprite;
public var mechanicCard2:FlxSprite;
public var mechanicCard3:FlxSprite;

var mechanicCardID1:Int = -1;
var mechanicCardID2:Int = -1;
var mechanicCardID3:Int = -1;

var nextMechanicBeat:Int = -1;

var finishedWindow:Float = hitWindow * 0.5;
var startWindow:Float = finishedWindow + 700;

var swaperooActive:Bool = false;
var painkillerActive:Bool = false;
var ruggedGemActive:Bool = false;

var ruggedGemDrainTimer:Float = 0;
var ruggedGemDrainDuration:Float = 10;
var ruggedGemDrainTimeLeft:Float = 0;
var ruggedGemDrainTick:Float = 0.1;
var ruggedGemDrainAmount:Float = 0.025;


function create() {
    strumLines.members[1].onNoteUpdate.add(onNoteUpdate);
}

//i will fix this later -megas
//fucking stupoid bug sprite
function stepHit(step:Int)
{
    switch (step) {
        case 10:
        // this how to use this
        // get random var mechanicCardID1 = FlxG.random.int(0,4);
        // trace(opsional)
        // and function mechanic(mechanicCard1 = new FlxSprite, mechanicCardID1)
        // witch you can use 3 card at one or or alternately like 
        // this have 10 cooldown soo dont put another same CardID 
            cardTransition();
        case 34:
        mechanicCardID1 = 4;
        //trace("Mechanic Card 1 ID = " + mechanicCardID1);
        mechanic(mechanicCard1 = new FlxSprite(), mechanicCardID1);
    }

}

function beatHit(curBeat:Int)
{
    if (curBeat >= nextMechanicBeat)
    {
        mechanicCardID1 = FlxG.random.int(0, 4);
        trace("Mechanic Card ID = " + mechanicCardID1);
        mechanicCard1 = new FlxSprite();
        mechanic(mechanicCard1, mechanicCardID1);
        nextMechanicBeat += 40;
    }
}
function setupCardFrames(sprite:FlxSprite) {
    sprite.frames = Paths.getSparrowAtlas("stages/showrunner/card");
    sprite.animation.addByPrefix("idle","card idle",1,true);
    sprite.animation.addByPrefix("reveal","card reveal",8,false);
    sprite.animation.addByPrefix("painkiller","card painkiller",1,false);
    sprite.animation.addByPrefix("pursuit","card pursuit",1,false);
    sprite.animation.addByPrefix("ruggedgem","card ruggedgem",1,false);
    sprite.animation.addByPrefix("slowburn","card slowburn",1,false);
    sprite.animation.addByPrefix("swaperoo","card swaperoo",1,false);
}

function cardTransition() {
    card = new FlxSprite();
    setupCardFrames(card);
    card.animation.play("idle");
    card.scale.set(0.3, 0.3);
    card.cameras = [camHUD];
    card.updateHitbox();
    card.x = -250;
    card.y = 390;
    add(card);
    FlxTween.tween(card,{x: card.x + 250},0.5,{ease: FlxEase.circOut});
    FlxG.sound.play(Paths.sound('card' + FlxG.random.int(3, 4)),1.5);
}

function mechanic(
    sprite:FlxSprite,
    id:Int
) {
    setupCardFrames(sprite);
    sprite.animation.play("idle");
    sprite.scale.set(0.3, 0.3);
    sprite.cameras = [camHUD];
    sprite.updateHitbox();
    sprite.x = card.x;
    sprite.y = card.y;
    add(sprite);
    FlxG.sound.play(Paths.sound('card' + FlxG.random.int(3, 4)),1.5);
    FlxTween.tween(sprite,{x: card.x + 270},0.5,{ease: FlxEase.quartOut});
    FlxTween.tween(sprite.scale,{x: 0.5,y: 0.5},1.5,{ease: FlxEase.quartOut,
    
        onComplete: function(twn:FlxTween) {
            revealCard(sprite,id);
            }});
}

function playCardAnimation(
    sprite:FlxSprite,
    id:Int
) {
    switch (id) {
        // 0 = Painkiller
        case 0:
            sprite.animation.play("painkiller");
        // 1 = RuggedGem
        case 1:
            sprite.animation.play("ruggedgem");
        // 2 = Pursuit
        case 2:
            sprite.animation.play("pursuit");
        // 3 = SlowBurn
        case 3:
            sprite.animation.play("slowburn");
        // 4 = Swaperoo
        case 4:
            sprite.animation.play("swaperoo");
        default:
            sprite.animation.play("idle");
    }
}

function revealCard(sprite:FlxSprite, id:Int) {
    FlxG.sound.play(Paths.sound('card' + FlxG.random.int(3, 4)),1.5);
    sprite.animation.play("idle");
    FlxTween.tween(sprite.scale,{y:0},0.25,{ease: FlxEase.quadOut, 
        onComplete: function(twn:FlxTween){
            playCardAnimation(sprite, id);
            activateMechanic(id);
            FlxTween.tween(sprite.scale, {y: 0.5}, 0.5,{ease: FlxEase.quadOut, 
                onComplete: function(twn:FlxTween) {
                    new FlxTimer().start(10, function(timer:FlxTimer) {
                        FlxTween.tween(sprite.scale, {y: 0}, 0.25, {ease: FlxEase.quadOut});
                        FlxG.sound.play(Paths.sound('card' + FlxG.random.int(1, 4)),1.5);
                        deactivateMechanic(id);
                    });
                }
                });

}});}



function activateMechanic(id:Int) {
    switch (id) {
        // 0 - PAINKILLER
        case 0:
            painkillerActive = true;
        // 1 - RUGGED GEM
        case 1:
            ruggedGemDrainTimer = 0;
            ruggedGemDrainTimeLeft = ruggedGemDrainDuration;
            ruggedGemActive = true;
        // 2 - PURSUIT
        case 2:
            FlxTween.num(3,4,(Conductor.stepCrochet / 1000) * 26,{ease: FlxEase.circOut},function(val:Float) {scrollSpeed = val;});
        // 3 - SLOW BURN
        case 3:
            FlxTween.num(
                3,
                2,
                (Conductor.stepCrochet / 1000) * 26,{ease: FlxEase.circOut},function(val:Float) {scrollSpeed = val;});
        case 4:
            swaperooActive = true;
    }
}

function deactivateMechanic(id:Int) {

    switch (id) {
        case 0:
            painkillerActive = false;
        case 1:
            ruggedGemActive = false;
            ruggedGemDrainTimer = 0;
            ruggedGemDrainTimeLeft = 0;
        case 2:
            FlxTween.num(4,3,(Conductor.stepCrochet / 1000) * 26,{ease: FlxEase.circOut},function(val:Float) {scrollSpeed = val;});
        case 3:
            FlxTween.num(2,3,(Conductor.stepCrochet / 1000) * 26,{ease: FlxEase.circOut},function(val:Float) {scrollSpeed = val;});
        case 4:
            swaperooActive = false;
    }
}

//mak aku ada di mod orang lain! -megas
//i'm stole this from undyne note fnd
function onNoteUpdate(e:NoteUpdateEvent) {
    var note:Note = e.note;
    if (note == null)
        return;
    if (!swaperooActive)
        return;
    var timeUntilNote:Float = note.strumTime - Conductor.songPosition;
    if (!note.extra.exists("swaperooAffected") && !note.extra.exists("swaperooIgnored")
    ) {
        if (timeUntilNote > hitWindow) {
            note.extra["swaperooAffected"] = true;
            trace("Swaperoo affected note: "+ note.noteData+ " | timeUntilNote = "+ timeUntilNote);
        } else {
            note.extra["swaperooIgnored"] = true;
            return;
        }
    }
    if (!note.extra.exists("swaperooAffected"))
        return;
    if (note.extra.exists("wasMoved") && note.extra["wasMoved"]) {
        note.extra["wasMoved"] = false;
        e.__reposNote = false;
        return;
    }
    var finishedWindow:Float = hitWindow * 0.5;
    var startWindow:Float = finishedWindow + 250;
    var strumTo:Strum = strumLines.members[1].members[note.noteData];
    var targetX:Float =strumTo.x + ((strumTo.width - note.width) / 2);
    var oppositeData:Int = switch (note.noteData) {
        case 0:
            3;
        case 1:
            2;
        case 2:
            1;
        case 3:
            0;
        default:
            note.noteData;
    };
    var strumFrom:Strum = strumLines.members[1].members[oppositeData];
    var startX:Float =strumFrom.x + ((strumFrom.width - note.width) / 2);
    var lerpedX:Float;
    var angleLerp:Float;
    if (timeUntilNote >= startWindow) {
        lerpedX = startX;
        angleLerp = 90;
    }
    else if (timeUntilNote <= finishedWindow) {
        lerpedX = targetX;
        angleLerp = 0;
    }
    else {
        var progress:Float =1 - ((timeUntilNote - finishedWindow) /(startWindow - finishedWindow));
        progress = FlxMath.bound(progress, 0, 1);
        progress = FlxEase.backOut(progress);
        lerpedX = FlxMath.lerp(startX,targetX, progress);
        angleLerp =FlxMath.lerp(90,0,progress);
    }
    var baseScrollFactor:Float =0.42 * CoolUtil.quantize(scrollSpeed, 200);
    var posY:Float = timeUntilNote * baseScrollFactor;
    if (note.isSustainNote) {
        posY += Strum.N_WIDTHDIV2;
    }
    posY += strumTo.y;
    e.__reposNote = false;
    note.extra["wasMoved"] = true;
    note.x = lerpedX;
    note.y = posY;
    note.angle = angleLerp;
    var curTail:Note = note.nextNote;
    while (
        curTail != null &&
        curTail.isSustainNote
    ) {
        var tailTime:Float =
            curTail.strumTime -
            Conductor.songPosition;

        var tailY:Float =
            tailTime *
            baseScrollFactor;

        tailY += Strum.N_WIDTHDIV2;
        tailY += strumTo.y;
        curTail.x = lerpedX + ((note.width - curTail.width) / 2);
        curTail.y = tailY;
        curTail.angle = angleLerp;
        curTail.extra["wasMoved"] = true;
        curTail = curTail.nextNote;
    }
}

function onNoteHit(event) {
    if (painkillerActive) {
        event.healthGain = 0;
    }
}

function update(elapsed:Float) {
    if (!ruggedGemActive)
        return;
    ruggedGemDrainTimer += elapsed;
    ruggedGemDrainTimeLeft -= elapsed;
    if (ruggedGemDrainTimer >= ruggedGemDrainTick) {
        ruggedGemDrainTimer -= ruggedGemDrainTick;
        if (health > 0.08) {
            health -= ruggedGemDrainAmount;
            if (health < 0.08)
                health = 0.08;
        }
    }
}