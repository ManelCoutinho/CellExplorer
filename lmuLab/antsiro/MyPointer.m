function MyPointer(name)
fname= ['/home/manuelc/matlab/CellExplorer-master/my_code/antsiro/cursor/' name '.map']; % TODO: change later
if FileExists(fname)
    map = load(fname);
    set(gcf,'PointerShapeCData',map);
    set(gcf,'Pointer','custom');
else
    fprintf('cursor %s does not exist\n',name);
end