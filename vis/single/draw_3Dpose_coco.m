function draw_3Dpose_coco()
    
    root_path = '/mnt/hdd1/Data/Human_pose_estimation/COCO/2017/val2017/';
    save_path = './vis/';
    num_joint =  17;
    mkdir(save_path);

    colorList_skeleton = [
    255/255 128/255 0/255;
    255/255 153/255 51/255;
    255/255 178/255 102/255;
    230/255 230/255 0/255;

    255/255 153/255 255/255;
    153/255 204/255 255/255;

    255/255 102/255 255/255;
    255/255 51/255 255/255;

    102/255 178/255 255/255;
    51/255 153/255 255/255;

    255/255 153/255 153/255;
    255/255 102/255 102/255;
    255/255 51/255 51/255;

    153/255 255/255 153/255;
    102/255 255/255 102/255;
    51/255 255/255 51/255;
    ];
    colorList_joint = [
    255/255 128/255 0/255;
    255/255 153/255 51/255;
    255/255 153/255 153/255;
    255/255 102/255 102/255;
    255/255 51/255 51/255;
    153/255 255/255 153/255;
    102/255 255/255 102/255;
    51/255 255/255 51/255;
    255/255 153/255 255/255;
    255/255 102/255 255/255;
    255/255 51/255 255/255;
    153/255 204/255 255/255;
    102/255 178/255 255/255;
    51/255 153/255 255/255;
    230/255 230/255 0/255;
    230/255 230/255 0/255;
    255/255 178/255 102/255;

    ];
    skeleton = [ [0, 16], [1, 16], [1, 15], [15, 14], [14, 8], [14, 11], [8, 9], [9, 10], [11, 12], [12, 13], [1, 2], [2, 3], [3, 4], [1, 5], [5, 6], [6, 7] ];
    skeleton = transpose(reshape(skeleton,[2,16])) + 1;

    fp_img_name = fopen('../coco_img_name.txt');
    preds_2d_kpt = load('preds_2d_kpt_coco.mat');
    preds_3d_kpt = load('preds_3d_kpt_coco.mat');
    
    img_name = fgetl(fp_img_name);
    while ischar(img_name)
        if isfield(preds_2d_kpt,img_name)
            pred_2d_kpt = getfield(preds_2d_kpt,img_name);
            pred_3d_kpt = getfield(preds_3d_kpt,img_name);
            
            img_name = strsplit(img_name,'_');
            img_name = strcat(img_name{2},'.jpg');
            img_path = strcat(root_path,img_name);
 
            num_pred = size(pred_2d_kpt,1);
            for i = 1:num_pred

                img = draw_2Dskeleton(img_path,pred_2d_kpt(i,:,:),num_joint,skeleton,colorList_joint,colorList_skeleton);
                save_name = strsplit(img_name,'.');
                save_name = save_name{1};
                save_name = strcat(save_name,sprintf('_%d_2d.jpg',i));
                disp(strcat(save_path,save_name));
                imwrite(img,strcat(save_path,save_name));

                f = draw_3Dskeleton(pred_3d_kpt(i,:,:),num_joint,skeleton,colorList_joint,colorList_skeleton);
                set(gcf, 'InvertHardCopy', 'off');
                set(gcf,'color','w');
                save_name = strsplit(img_name,'.');
                save_name = save_name{1};
                save_name = strcat(save_name,sprintf('_%d_3d.jpg',i));
                saveas(f, strcat(save_path,save_name));
                close(f);
            end
           
        end

        img_name = fgetl(fp_img_name);
    end
        
end
