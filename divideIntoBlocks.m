function dividedImage = divideIntoBlocks(InputImage,BlockSize)
img1 = InputImage;
TOTAL_BLOCKS = size(img1,1)*size(img1,2) / (BlockSize*BlockSize);
dividedImage = zeros([BlockSize BlockSize TOTAL_BLOCKS]);
row = 1;
col = 1;
try
    for count=1:TOTAL_BLOCKS
        dividedImage(:,:,count) = img1(row:row+BlockSize-1,col:col+BlockSize-1);
        col = col + BlockSize;
        if(col >= size(img1,2))
            col = 1;
            row = row + BlockSize;
            if(row >= size(img1,1))
                row = 1;
            end
        end
    end
end