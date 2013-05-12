var Animator = function() {
	
    this.context = document.getElementById('myCanvas').getContext('2d');
    this.background = new Image();
    this.sprite = new Image();
    this.background.src = 'grass.png';
    this.sprite.src = 'sprite.png';
    this.spriteFrame = 0;
    this.offset = 0;
    this.stopped = false;
    this.direction = 'right';
    this.offset = 0;
    
    var self = this;

    this.run = function() {
        setInterval(this.tick, 66);
    };

    this.tick = function() {
        if(self.stopped) { return ;}
        if(self.direction === 'right') {
            if(self.offset > -32) {
                self.offset = self.offset - 4;
            }
            else {
                self.offset = -4; 
            }
            self.context.drawImage(self.background, self.offset, 0);
            if(self.spriteFrame > 1) {
                self.spriteFrame = 0;
            }
            else {
                self.spriteFrame++;
            }
            self.context.drawImage(self.sprite, 0 + (self.spriteFrame*96), 0, 96, 96, 256, 128, 96, 96);  
        }
        else {
            if(self.offset < -4) {
                self.offset = self.offset + 4;
            }
            else {
                self.offset = -32; 
            }
            self.context.drawImage(self.background, self.offset, 0);

            if(self.spriteFrame > 1) {
                self.spriteFrame = 0;
            }
            else {
                self.spriteFrame ++;
            }
            self.context.drawImage(self.sprite, 0 + (self.spriteFrame*96), 96, 96, 96, 256, 128, 96, 96);                
        }    
    }
}