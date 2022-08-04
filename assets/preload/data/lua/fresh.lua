function start(song) -- copied from github, thanks kadedev. idoiots who don't know modhcarts, use this
    
end


function update(elapsed)

end

function playerTwoTurn()
    
end

function playerOneTurn()

end

-- this gets called every beat
function beatHit(beat) -- arguments, the current beat of the song

end

-- this gets called every step
function stepHit(step) -- arguments, the current step of the song (4 steps are in a beat)
    if curStep == 0 then
        toggleCinematicMode();
    end
    if curStep == 65 then
        toggleCinematicMode();
    end
    if curStep == 190 then
        toggleCinematicMode();
    end
    if curStep == 320 then
        toggleCinematicMode();
    end
    if curStep == 576 then
        toggleCinematicMode();
    end
    if curStep == 640 then
        toggleCinematicMode();
    end
end