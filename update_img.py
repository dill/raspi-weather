## DEBUG version of update_img
import sys

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

    # For simplicity, the arguments are explicit numerical coordinates
    # 255: clear the image with white
    image = Image.new('1', (264, 176), 255)
    draw = ImageDraw.Draw(image)

    # pick a font for the text
    font = ImageFont.truetype('Lato-Bold.ttf', 18)
    font_med = ImageFont.truetype('Lato-Bold.ttf', 14)

    # now do some drawing, working roughly from top left to bottom right...

    # add weather icon
    image.paste(transparent_to_white(ico_path), (-5, -5))

    # date
    draw.text((70, 2), today, font = font, fill = 0)

    # moon phase icon
    image.paste(transparent_to_white(moon_ico_path), (220, 0))

    # sunrise/sunset
    image.paste(transparent_to_white("icons/sunrise.png"), (70, 25))
    draw.text((98, 30), sunrise, font = font_med, fill = 0)
    image.paste(transparent_to_white("icons/sunset.png"), (140, 25))
    draw.text((170, 30), sunset, font = font_med, fill = 0)

    ## temperature
    # graphic pre-generated in R
    image.paste(transparent_to_white('Rtmp/temp.png'), (0, 95))

    ## wind
    image.paste(transparent_to_white('icons/wind.png'), (5, 60))
    draw.text((40, 60), wind, font = font_med, fill = 0)
    draw.text((40, 75), gust, font = font_med, fill = 0)

    ## tides
    for i in range(len(tide_stat)):
        image.paste(transparent_to_white("icons/water.png"), (95+i*80, 65))
        image.paste(transparent_to_white("icons/arrow.png").rotate(tide_stat[i]), (115+i*80, 65))
        draw.text((137+i*80, 67), tide_time[i], font = font_med, fill = 0)


    # we've built a landscape image, need to rotate it into place
    #image = image.rotate(270, expand=1)
    image.save("tmp.png","png")


#display_weather("Saturday 12 September", "HH:MM", "HH:MM", "00C", "00C", "icons/weather/1F326.png", (0, 180), ("5m","10m"), ("HH:MM", "HH:MM"))
