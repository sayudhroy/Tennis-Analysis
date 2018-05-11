function court = CreateCourt()
court = zeros(390+160,180+40);
%horizontal
court(470, 20:200) = 255;
court(80,  20:200) = 255;
%vertical
court(80:470, 20) = 255;
court(80:470, 200) = 255;
%center
court(275, 20:200) = 255;
%side
court(80:470, 20+22) = 255;
court(80:470, 200-22) = 255;
%service line
court(275+105, 20+22:200-22) = 255;
court(275-105, 20+22:200-22) = 255;
%center service line
court(170:275+105,20+90) = 255;
%small marks
court(80:85,20+90) = 255;
court(465:470,20+90) = 255;
end