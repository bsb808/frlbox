function gpt = parseGPTmsg(inMsg)

% parser for GPT messages from mission planner
% GPT <timestr> <gid> <name> <timeoutsec> <trigger> <x1> <y1> <z1> <x2> <y2> <z2> <hdg> <xyvel> <zvel>
% NoValue is typically -98765;
% NOVAL = -98765;

[label,dnum,datastr] = parseDSLog(inMsg);
% verify this worked

% parse the datastr
C = textscan(datastr,'%d %s %d %d %f %f %f %f %f %f %f %f %f');
if isempty(C{end})
	gpt = -1;
	return;
end
gpt.label = label;
gpt.t = t_mat2unix(dnum);
gpt.gid = C{1};
gpt.name = C{2};
gpt.to = C{3};
gpt.trigger = C{4};
gpt.x1 = C{5};
gpt.y1 = C{6};
gpt.z1 = C{7};
gpt.x2 = C{8};
gpt.y2 = C{9};
gpt.z2 = C{10};
gpt.hdg = C{11};
gpt.xyvel = C{12};
gpt.zvel = C{13};



