function srt2webvtt(data) {
    // remove dos newlines
    var srt = data.replace(/\r+/g, '');
    // trim white space start and end
    srt = srt.replace(/^\s+|\s+$/g, '');
    
    // get cues
    var cuelist = srt.split('\n\n');
    var result = "";
    
    if (cuelist.length > 0) {
        result += "WEBVTT\n\n";
        for (var i = 0; i < cuelist.length; i=i+1) {
            result += convertSrtCue(cuelist[i]);
        }
    }
    
    return result;
}

function srt2webvtt2(data, delay, enablestyle) {
    // remove dos newlines
    var srt = data.replace(/\r+/g, '');
    // trim white space start and end
    srt = srt.replace(/^\s+|\s+$/g, '');
//    srt = srt.replace(/\n\n(\d+\n\d{2,2}:\d{2,2}:\d{2,2},\d{3,3}\s+-->\s+\d{2,2}:\d{2,2}:\d{2,2},\d{3,3})/g,'\n$1');
    srt = srt.replace(/\n\n/g, '\n');
    srt = srt.replace(/\n(\d+\n\d{2,2}:\d{2,2}:\d{2,2},\d{3,3}\s+-->\s+\d{2,2}:\d{2,2}:\d{2,2},\d{3,3})/g,'\n\n$1');
    // get cues
    var cuelist = srt.split('\n\n');
    var result = "";
    
    if (cuelist.length > 0) {
        result += "WEBVTT\n\n";
        for (var i = 0; i < cuelist.length; i=i+1) {
            result += convertSrtCue(cuelist[i], delay, enablestyle);
        }
    }
    
    return result;
}


function convertSrtCue(caption, delay, enablestyle) {
    // remove all html tags for security reasons
    //srt = srt.replace(/<[a-zA-Z\/][^>]*>/g, '');
    
    var cue = "";
    var s = caption.split(/\n/);

    // concatenate muilt-line string separated in array into one
    while (s.length > 3) {
        for (var i = 3; i < s.length; i++) {
            s[2] += "\n" + s[i]
        }
        s.splice(3, s.length - 3);
    }
    
    var line = 0;
    
    // detect identifier
    if (!s[0].match(/\d+:\d+:\d+/) && s[1].match(/\d+:\d+:\d+/)) {
        cue += s[0].match(/\w+/) + "\n";
        line += 1;
    }

    // get time strings
    if (s[line].match(/\d+:\d+:\d+/)) {
        // convert time string
        var m = s[1].match(/(\d+):(\d+):(\d+)(?:,(\d+))?\s*--?>\s*(\d+):(\d+):(\d+)(?:,(\d+))?/);
        if (m) {
            var time1 = parseInt(m[1]) * 60 * 60 + parseInt(m[2]) * 60 + parseInt(m[3]);
            time1 -= delay;
            if (time1 < 0) {
                time1 = 0;
            }
            var h1 = Math.floor(time1 / 3600);
            if (h1 <= 9) {
                h1 = "0" + h1;
            }
            time1 -= h1 * 3600;
            var m1 = Math.floor(time1 / 60);
            if (m1 <= 9) {
                m1 = "0" + m1;
            }
            var s1 = time1 % 60;
            if (s1 <= 9) {
                s1 = "0" + s1;
            }
            
            var time2 = parseInt(m[5]) * 60 * 60 + parseInt(m[6]) * 60 + parseInt(m[7]);
            time2 -= delay;
            if (time2 < 0) {
                time2 = 0;
            }
            var h2 = Math.floor(time2 / 3600);
            if (h2 <= 9) {
                h2 = "0" + h2;
            }
            
            time2 -= h2 * 3600;
            var m2 = Math.floor(time2 / 60);
            var s2 = time2 % 60;
            if (m2 <= 9) {
                m2 = "0" + m2;
            }
            if (s2 <= 9) {
                s2 = "0" + s2;
            }
            
            if (enablestyle == "yes") {
                cue += h1 + ":" + m1 + ":" + s1 + "." + m[4] + " --> " +
                h2 + ":" + m2 + ":" + s2 + "." + m[8] + " line:-1 position:50% align:center size:100%\n";
            } else {
                cue += h1 + ":" + m1 + ":" + s1 + "." + m[4] + " --> " +
                h2 + ":" + m2 + ":" + s2 + "." + m[8] + "\n";
            }
            //            cue += m[1]+":"+m[2]+":"+m[3]+"."+m[4]+" --> "
            //            +m[5]+":"+m[6]+":"+m[7]+"."+m[8]+" line:-1 position:50% align:center size:100%\n";
            
            line += 1;
        } else {
            // Unrecognized timestring
            return "";
        }
    } else {
        // file format error or comment lines
        return "";
    }

    // get cue text
    if (s[line]) {
        cue += s[line] + "\n\n";
    }

    return cue;
}


var buf = []
var first = true
re_ass = new RegExp("Dialogue:\\s\\d," +
                    "(\\d+:\\d\\d:\\d\\d.\\d\\d)," +
                    "(\\d+:\\d\\d:\\d\\d.\\d\\d)," +
                    "([^,]*)," +
                    "([^,]*)," +
                    "(?:[^,]*,){4}" +
                    "(.*)$", "i");

re_newline = /\\N/ig;
re_style = /\{([^}]+)\}/;
var i = 1;
var write = function(line, delay, enablestyle, enc, cb) {
    var m = line.match(re_ass);
    if (!m) {
        return cb();
    }
    var start = m[1],
    end = m[2],
    what = m[3],
    actor = m[4],
    text = m[5];
    var style, pos_style = "",
    tagsToClose = []; // Places to stash style info.
    // Subtitles may contain any number of override tags, so we'll loop through
    // to find them all.
    while ((style = text.match(re_style))) {
        var tagsToOpen = [],
        replaceString = '';
        if (style[1] && style[1].split) { // Stop throwing errors on empty tags.
            style = style[1].split("\\"); // Get an array of override commands.
            for (var j = 1; j < style.length; j++) {
                var firstLetter = style[j].substring(0, 1);
                
                // "New" position commands. It is assumed that bottom center position is the default.
                if (style[j].substring(0, 2) === "an") {
                    var posNum = Number(style[j].substring(2, 3));
                    if (Math.floor((posNum - 1) / 3) == 1) {
                        pos_style += ' line:50%';
                    } else if (Math.floor((posNum - 1) / 3) == 2) {
                        pos_style += ' line:0';
                    }
                    if (posNum % 3 == 1) {
                        pos_style += ' align:start';
                    } else if (posNum % 3 == 0) {
                        pos_style += ' align:end';
                    }
                    // Legacy position commands.
                } else if (firstLetter === "a" && !Number.isNaN(Number(style[j].substring(1, 2)))) {
                    var posNum = Number(style[j].substring(1, 2));
                    if (posNum > 8) {
                        pos_style += ' line:50%';
                    } else if (posNum > 4) {
                        pos_style += ' line:0';
                    }
                    if ((posNum - 1) % 4 == 0) {
                        pos_style += ' align:start';
                    } else if ((posNum - 1) % 4 == 2) {
                        pos_style += ' align:end';
                    }
                    // Map simple text decoration commands to equivalent WebVTT text tags.
                    // NOTE: Strikethrough (the 's' tag) is not supported in WebVTT.
                } else if (['b', 'i', 'u', 's'].includes(firstLetter)) {
                    if (Number(style[j].substring(1, 2)) === 0) {
                        // Closing a tag.
                        if (tagsToClose.includes(firstLetter)) {
                            // Nothing needs to be done if this tag isn't already open.
                            // HTML tags must be nested, so we must ensure that any tag nested inside
                            // the tag being closed are also closed, and then opened again once the
                            // current tag is closed.
                            while (tagsToClose.length > 0) {
                                var nowClosing = tagsToClose.pop();
                                replaceString += '</' + nowClosing + '>';
                                if (nowClosing !== firstLetter) {
                                    tagsToOpen.push(nowClosing);
                                } else {
                                    // There's no need to close the tags that the current tag
                                    // is nested within.
                                    break;
                                }
                            }
                        }
                    } else {
                        // Opening a tag.
                        if (!tagsToClose.includes(firstLetter)) {
                            // Nothing needs to be done if the tag is already open.
                            // If no, place the tag on the bottom of the stack of tags being opened.
                            tagsToOpen.splice(0, 0, firstLetter);
                        }
                    }
                }
                
                // Insert open-tags for tags in the to-open list.
                while (tagsToOpen.length > 0) {
                    var nowOpening = tagsToOpen.pop();
                    replaceString += '<' + nowOpening + '>';
                    tagsToClose.push(nowOpening);
                }
            }
        }
        text = text.replace(re_style, replaceString); // Replace override tag.
    }
    
    text = text.replace(re_newline, "\r\n");
    var content = i + "\r\n"
    if (enablestyle == "yes") {
        pos_style = " line:-1 position:50% align:center size:100%"
    }
    
    var timestring = start + " --> " + end;
    var mstart = timestring.match(/(\d+):(\d+):(\d+)(?:\.(\d+))?\s*--?>\s*(\d+):(\d+):(\d+)(?:\.(\d+))?/);
    if (mstart) {
        var time1 = parseInt(mstart[1]) * 60 * 60 + parseInt(mstart[2]) * 60 + parseInt(mstart[3]);
        time1 -= delay;
        if (time1 < 0) {
            time1 = 0;
        }
        var h1 = Math.floor(time1 / 3600);
        time1 -= h1 * 3600;
        var m1 = Math.floor(time1 / 60);
        if (m1 <= 9) {
            m1 = "0" + m1;
        }
        var s1 = time1 % 60;
        if (s1 <= 9) {
            s1 = "0" + s1;
        }
        start = h1 + ":" + m1 + ":" + s1 + "." + mstart[4];
        
        var time2 = parseInt(mstart[5]) * 60 * 60 + parseInt(mstart[6]) * 60 + parseInt(mstart[7]);
        time2 -= delay;
        if (time2 < 0) {
            time2 = 0;
        }
        var h2 = Math.floor(time2 / 3600);
        time2 -= h2 * 3600;
        var m2 = Math.floor(time2 / 60);
        var s2 = time2 % 60;
        if (m2 <= 9) {
            m2 = "0" + m2;
        }
        if (s2 <= 9) {
            s2 = "0" + s2;
        }
        
        end = h2 + ":" + m2 + ":" + s2 + "." + mstart[8];
    }
    
    content += "0" + start + "0 --> 0" + end + "0" + pos_style + "\r\n"
    content += text
    while (tagsToClose.length > 0) {
        content += '</' + tagsToClose.pop() + '>';
    }
    content += "\r\n\r\n";
    i++;
    cb(null, content)
}
var ass2vtt = function(data, delay, enablestyle) {
    var cuelist = data.split(/\r?\n/);
    var result = "";
    if (cuelist.length > 0) {
        result += "WEBVTT\r\n\r\n";
        for (var i in cuelist) {
            write(cuelist[i], delay, enablestyle, "utf-8", function(e, data) {
                  if (data) result += data;
                  });
        }
    }
    return result;
}
