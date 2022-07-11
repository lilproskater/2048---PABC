uses GraphABC;

const size: integer = 3;
var field: array [0..size] of array [ 0..size] of integer;


procedure initWindow();
begin
    Window.Width := 500;
    Window.Height := 600;
    Window.IsFixedSize := true;
    Window.CenterOnScreen();
    Window.Title := '2048 - Game';
    setPenColor(clTransparent);
    clearWindow(rgb(251, 248, 239));
    LockDrawing();
end;


procedure spawn();
begin
    var random_idx_x := random(0, size);
    var random_idx_y := random(0, size);
    while (field[random_idx_y][random_idx_x] <> 0) do
    begin
        random_idx_x := random(0, size);
        random_idx_y := random(0, size);
    end;
    field[random_idx_y][random_idx_x] := random(1, 2) * 2;
end;


procedure initGame();
begin
    // initialize filed array with 0-s
    for var i := 0 to size do
        for var j := 0 to size do
            field[i][j] := 0;
    for var i := 0 to 1 do
        spawn();
end;


procedure drawField();
begin
    var offsetX := 25;
    var offsetY := Window.Height - Window.Width + offsetX;
    var fieldWidth := (Window.Width - offsetX * 2);
    var tileSize := Round(fieldWidth / 4);
    setPenColor(rgb(167, 148, 129));
    setPenWidth(5);
    setFontSize(24);
    setFontStyle(fsBold);
    var brushColor: color;
    for var i := 0 to size do
        for var j := 0 to size do
        begin
            case field[i][j] of
                2: brushColor := rgb(240, 228, 220);
                4: brushColor := rgb(238, 226, 201);
                8: brushColor := rgb(243, 177, 123);
                else brushColor := rgb(193, 175, 161);
            end;
            setBrushColor(brushColor);
            Rectangle(j*tileSize + offsetX, i*tileSize + offsetY, (j + 1)*tileSize + offsetX, (i + 1)*tileSize + offsetY);
            if (field[i][j] <> 0) then
                drawTextCentered(j*tileSize + offsetX, i*tileSize + offsetY, (j + 1)*tileSize + offsetX, (i + 1)*tileSize + offsetY, field[i][j]);
        end;
    Redraw();
end;


procedure moveRight();
begin
    for var i := 0 to size do
    begin
        var new_row: array [0..size] of integer := (0, 0, 0, 0);
        var idx := size;
        for var j := size downto 0 do
        begin
            if (field[i][j] <> 0) then
            begin
                new_row[idx] := field[i][j];
                idx -= 1;
            end;
        end;
        
        // Add same numbers
        for var j := size downto 0 do
        begin
            if (j > 0) and (new_row[j] = new_row[j - 1]) then
            begin
                new_row[j] += new_row[j - 1];
                for var k := j - 1 downto 1 do
                    new_row[k] := new_row[k - 1];
                new_row[0] := 0;
            end;
        end;
        for var j := 0 to size do
            field[i][j] := new_row[j];
    end;
end;


procedure moveDown();
begin
    for var i := 0 to size do
    begin
        var new_col: array [0..size] of integer := (0, 0, 0, 0);
        var idx := size;
        for var j := size downto 0 do
        begin
            if (field[j][i] <> 0) then
            begin
                new_col[idx] := field[j][i];
                idx -= 1;
            end;
        end;
        
        // Add same numbers
        for var j := size downto 0 do
        begin
            if (j > 0) and (new_col[j] = new_col[j - 1]) then
            begin
                new_col[j] += new_col[j - 1];
                for var k := j - 1 downto 1 do
                    new_col[k] := new_col[k - 1];
                new_col[0] := 0;
            end;
        end;
        for var j := 0 to size do
            field[j][i] := new_col[j];
    end;
end;


procedure moveLeft();
begin
    for var i := 0 to size do
    begin
        var new_row: array [0..size] of integer := (0, 0, 0, 0);
        var idx := 0;
        for var j := 0 to size do
        begin
            if (field[i][j] <> 0) then
            begin
                new_row[idx] := field[i][j];
                idx += 1;
            end;
        end;
        
        // Add same numbers
        for var j := 0 to size do
        begin
            if (j < size) and (new_row[j] = new_row[j + 1]) then
            begin
                new_row[j] += new_row[j + 1];
                for var k := j + 1 to size - 1 do
                    new_row[k] := new_row[k + 1];
                new_row[size] := 0;
            end;
        end;
        for var j := 0 to size do
            field[i][j] := new_row[j];
    end;
end;


procedure moveUp();
begin
    for var i := 0 to size do
    begin
        var new_col: array [0..size] of integer := (0, 0, 0, 0);
        var idx := 0;
        for var j := 0 to size do
        begin
            if (field[j][i] <> 0) then
            begin
                new_col[idx] := field[j][i];
                idx += 1;
            end;
        end;
        
        // Add same numbers
        for var j := 0 to size do
        begin
            if (j < size) and (new_col[j] = new_col[j + 1]) then
            begin
                new_col[j] += new_col[j + 1];
                for var k := j + 1 to size - 1 do
                    new_col[k] := new_col[k + 1];
                new_col[size] := 0;
            end;
        end;
        for var j := 0 to size do
            field[j][i] := new_col[j];
    end;
end;


procedure moveAndSpawn(direction: String);
begin
    direction := direction.ToLower();
    case direction of
        'right': moveRight();
        'left': moveLeft();
        'down': moveDown();
        'up': moveUp();
    end;
    spawn();
end;


procedure KeyDown(key: integer);
begin
    var direction := '';
    case key of
        VK_UP: direction := 'up';
        VK_DOWN: direction := 'down';
        VK_LEFT: direction := 'left';
        VK_RIGHT: direction := 'right';
    end;
    moveAndSpawn(direction);
end;


begin
    initWindow();
    initGame();
    onKeydown := KeyDown;
    while true do
        drawField();
end.
