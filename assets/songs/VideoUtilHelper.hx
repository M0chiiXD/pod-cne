// please place this file in yourmod/songs !!!

function onSubstateOpen(event) VideoUtil.pauseCur();
function onSubstateClose(event) VideoUtil.resumeCur();
function onFocus() if (paused) VideoUtil.pauseCur(); else VideoUtil.resumeCur();
function destroy() VideoUtil.clearList();
