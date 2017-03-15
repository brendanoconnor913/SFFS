% Loading all of the necessary data files
load Train_All_Data_DigiBGP.mat;
load Train_All_Label_DigiBGP.mat;
load Train_All_Data_DigiLBP.mat;
load Train_All_Label_DigiLBP.mat;
load Test_All_Data_DigiBGP.mat;
load Test_All_Label_DigiBGP.mat;
load Test_All_Data_DigiLBP.mat;
load Test_All_Label_DigiLBP.mat;

sffs(Train_All_Label_DigiBGP, Train_All_Data_DigiBGP,...
    Test_All_Label_DigiBGP, Test_All_Data_DigiBGP);

sffs(Train_All_Label_DigiLBP, Train_All_Data_DigiLBP,...
    Test_All_Label_DigiLBP, Test_All_Data_DigiLBP);


