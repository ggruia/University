import pygame


class Button:
    def __init__(self, display=None, left=0, top=0, width=0, height=0, bgColor=(53, 80, 115), selBgColor=(89, 134, 194), text="", font="arial", fontDim=16, color=(255,255,255), value=""):
        self.display = display
        self.bgColor = bgColor
        self.selBgColor = selBgColor
        self.left = 0
        self.top = 0
        self.width = width
        self.height = height
        self.isSelected = False
        self.value = value
        self.rect = pygame.Rect(left, top, width, height)
        self.renderedText = pygame.font.SysFont(font, fontDim).render(text, True, color)
        self.container = self.renderedText.get_rect(center=self.rect.center)
        

    def select(self, selection):
        self.isSelected = selection
        self.draw()
        
    def selectByCoords(self, coords):
        if self.container.collidepoint(coords):
            self.select(True)
            return True
        return False

    def updateRect(self):
        self.rect.left = self.left
        self.rect.top = self.top
        self.container = self.renderedText.get_rect(center=self.rect.center)

    def draw(self):
        bgColor = self.selBgColor if self.isSelected else self.bgColor
        pygame.draw.rect(self.display, bgColor, self.rect)
        self.display.blit(self.renderedText, self.container)



class ButtonGroup:
    def __init__(self, buttons:list[Button], selection=0, spaceBetween=10, left=0, top=0):
        self.buttons = buttons
        self.selectedBtn = selection
        self.buttons[self.selectedBtn].isSelected = True
        self.top = top
        self.left = left
        leftOrigin = self.left
        for btn in self.buttons:
            btn.top = self.top
            btn.left = leftOrigin
            leftOrigin += spaceBetween + btn.width
            btn.updateRect()


    def getValue(self):
        return self.buttons[self.selectedBtn].value

    def selectBtnByCoords(self, coord):
        for i, btn in enumerate(self.buttons):
            if btn.selectByCoords(coord):
                self.buttons[self.selectedBtn].select(False)
                self.selectedBtn = i
                return True
        return False

    def drawButtons(self):
        for btn in self.buttons:
            btn.draw()