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

def display_weather(today, sunrise, sunset, hightemp, lowtemp, ico_path, tide_stat, tide_height, tide_time, moon_ico_path, wind, gust):
    # initialize the display
    epd = epd2in7.EPD()
    epd.init()

    # For simplicity, the arguments are explicit numerical coordinates
    # 255: clear the image with white
    image = Image.new('1', (264, 176), 255)
    draw = ImageDraw.Draw(image)

    # pick a font for the text
    font = ImageFont.truetype('Lato-Bold.ttf', 18)
    font_med = ImageFont.truetype('Lato-Bold.ttf', 14)

    # date
    draw.text((70, 2), today, font = font, fill = 0)

    # sunrise/sunset
    image.paste(transparent_to_white("icons/sunrise.png"), (70, 40))
    draw.text((98, 45), sunrise, font = font_med, fill = 0)
    image.paste(transparent_to_white("icons/sunset.png"), (140, 40))
    draw.text((170, 45), sunset, font = font_med, fill = 0)

    ## left column
    # add weather icon
    image.paste(transparent_to_white(ico_path), (-5, -5))

    # temperature
    image.paste(transparent_to_white('icons/1F321.png'), (-20, 65))
    draw.text((35, 65), hightemp, font = font_med, fill = 0)
    draw.text((35, 115), lowtemp, font = font_med, fill = 0)

    # wind
    image.paste(transparent_to_white('icons/wind.png'), (5, 142))
    draw.text((40, 142), wind, font = font_med, fill = 0)
    draw.text((40, 157), gust, font = font_med, fill = 0)


    # tides
    for i in range(len(tide_height)):
        draw.text((108, 92+i*20), tide_height[i], font = font_med, fill = 0)
        image.paste(transparent_to_white("icons/water.png"), (140, 90+i*20))
        image.paste(transparent_to_white("icons/arrow.png").rotate(tide_stat[i]), (160, 88+i*20))
        draw.text((180, 92+i*20), tide_time[i], font = font_med, fill = 0)

    # moon phase icon
    image.paste(transparent_to_white(moon_ico_path), (220, 130))

    # we've built a landscape image, need to rotate it into place
    image = image.rotate(270, expand=1)
    epd.display_frame(epd.get_frame_buffer(image))

