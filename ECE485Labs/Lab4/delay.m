function [newTop, newBot] = delay(top, bot, g, a)
newTop = top(mod(1:length(top),length(top))+1);
newBot = bot(mod(-1:length(bot)-2,length(bot))+1);
newTop(end) = -bot(end);
newBot(1) = -top(1);
newTop(end) = g.*(a.*newTop(end-1) + (1-a).*newTop(end));
newBot(end) = g.*(a.*newBot(end-1) + (1-a).*newBot(end));
