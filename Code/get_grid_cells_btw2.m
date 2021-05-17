function points = get_grid_cells_btw2(x0,y0,x1,y1)
    dx = x1 - x0;
    dy = y1 - y0;
    
    if dx == 0
        step = sign(dy)*1;
        points = [];
        for y = 0:dy:step
            points = [points; x0,y];
            return;
        end
       
    end
    
    m = dy/(dx+0.0);
    b = y1-m*x0;
    
    points = [];
    step = 1.0/(max(abs(dx),abs(dy)));
    
    steps = [];
    for x = int64(x0/step):int64(x1/step + sign(x1)*1):int64(sign(dx)*1)
        steps = [steps; x*step];
    end
    
    for z = steps
        y = m*z+b;
        points = [points; int64(round(z)),int64(round(y))];
        return;
    end
    
    
    
    
    
    
    
end
