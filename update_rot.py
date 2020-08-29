import sys
sys.path.insert(1, "./lib")

import epd2in7
from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw
from PIL import ImageFile


def transparent_to_white(path):
    orig = Image.open(path).convert("RGBA")
    copy = Image.new("RGB", orig.size, "WHITE")
    copy.paste(orig, (0, 0), mask=orig) 
    return(copy)

def display_weather(today, sunrise, sunset, hightemp, lowtemp, ico_path, tide_stat, tide_height, tide_time, moon_ico_path):
    # initialize the display
    epd = epd2in7.EPD()
    epd.init()

    # For simplicity, the arguments are explicit numerical coordinates
    # 255: clear the image with white
    image = Image.new('1', (epd2in7.EPD_HEIGHT, epd2in7.EPD_WIDTH), 255)
    draw = ImageDraw.Draw(image)

    # pick a font for the text
    font = ImageFont.truetype('/usr/share/fonts/truetype/lato/Lato-Heavy.ttf', 18)
    font_med = ImageFont.truetype('/usr/share/fonts/truetype/lato/Lato-Heavy.ttf', 14)

    # add weather icon
    image.paste(transparent_to_white(ico_path), (0, 0))

    # date
    draw.text((70, 5), today, font = font, fill = 0)


    # temperature
    image.paste(transparent_to_white('icons/1F321.png'), (-20, 75))
    draw.text((35, 77), hightemp, font = font_med, fill = 0)
    draw.text((35, 125), lowtemp, font = font_med, fill = 0)

    # tides
    for i in range(len(tide_height)):
        draw.text((88, 52+i*20), tide_height[i], font = font_med, fill = 0)
        image.paste(transparent_to_white("icons/water.png"), (120, 50+i*20))
        image.paste(transparent_to_white("icons/arrow.png").rotate(tide_stat[i]), (140, 48+i*20))
        draw.text((160, 52+i*20), tide_time[i], font = font_med, fill = 0)
    

    # sunrise/sunset
    image.paste(transparent_to_white("icons/sunrise.png"), (0, 150))
    draw.text((28, 155), sunrise, font = font_med, fill = 0)
    image.paste(transparent_to_white("icons/sunset.png"), (100, 150))
    draw.text((130, 155), sunset, font = font_med, fill = 0)

    # moon phase icon
    image.paste(transparent_to_white(moon_ico_path), (220, 130))
    
    # we've built a landscape image, need to rotate it into place
    image = image.rotate(270, expand=1)
    epd.display_frame(epd.get_frame_buffer(image))


#display_weather("Saturday 12 September", "HH:MM", "HH:MM", "00C", "00C", "icons/weather/1F326.png", (0, 180), ("5m","10m"), ("HH:MM", "HH:MM"))
