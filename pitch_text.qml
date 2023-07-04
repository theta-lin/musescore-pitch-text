import MuseScore 3.0
import QtQuick 2.9

MuseScore
{
	menuPath: "Plugins.Pitch Text"

	function applyToSelectedNotes(func)
	{
		if (!curScore) return;

		var fullScore = !(curScore.selection.elements.length > 1);
		if (fullScore)
		{
			cmd("select-all");
			curScore.startCmd();
		}

		var elements = curScore.selection.elements;
		for (var i in elements)
		{
			if (elements[i].type == Element.NOTE)
			{
				func(elements[i]);
			}
		}

		if (fullScore)
		{
			curScore.endCmd();
			cmd("escape");
		}
	}

	function addText(note)
	{
		var track = note.track;
		var chord = note.parent;
		var seg = chord.parent;
		var tick = seg.tick;
		var cursor = curScore.newCursor();
		cursor.rewind(0);
		cursor.track = track;
		while (cursor.tick < tick) { cursor.next(); }

		var text = newElement(Element.STAFF_TEXT);
		text.fontSize = 7;
		var pitchText = (note.pitch % 12).toString(12);
		var interval = note.pitch - chord.notes[0].pitch;
		if (interval > 0)
		{
			pitchText += "(" + interval.toString(12) + ")";
		}
		text.text = pitchText;
		cursor.add(text);
	}

	onRun: {
		applyToSelectedNotes(addText);
	}
}
