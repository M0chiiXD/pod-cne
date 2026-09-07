function onEvent(e) {
    if (e.event.name == "Set Hold Suffix") {
        strumLines.members[e.event.params[0]].animSuffix = e.event.params[1];
		
        for (char in strumLines.members[e.event.params[0]].characters) {
            char.idleSuffix = e.event.params[1]; char.dance();
        }
    }
}