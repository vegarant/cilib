% Write the text "CAN YOU READ ME?" in the lower left corner of an image
%
% INPUT: 
% X - path to image
%
% OUTPUT
% A - image with the text "CAN U READ ME?"
% 
% Edvard Aksnes, 2017
function A = cil_add_text_to_brain(X)
  A = insertText(X,[1540 1012],'C','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1547 1018],'A','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1554 1026],'N','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1567 1030],'U','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1580 1033],'S','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1588 1032],'E','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1596 1031],'E','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  %A = insertText(A,[1604 1031],'D','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1612 1027],'I','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1622 1023],'T','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
  A = insertText(A,[1629 1015],'?','BoxOpacity',0.0,'FontSize',10,'TextColor','white');
end
