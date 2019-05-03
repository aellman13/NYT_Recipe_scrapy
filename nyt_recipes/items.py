# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class NytrecipesItem(scrapy.Item):
    
    yield_num = scrapy.Field()
    yield_metric = scrapy.Field()
    time_num = scrapy.Field()
    time_metric = scrapy.Field()
    description = scrapy.Field()
    author = scrapy.Field()
    recipe_title = scrapy.Field()
    rating = scrapy.Field()
    ingredient_amount = scrapy.Field()
    ingredient_name = scrapy.Field()
    cook_instructions = scrapy.Field()
    tags = scrapy.Field()
    picture_src = scrapy.Field()
    cook_category = scrapy.Field()
    url = scrapy.Field()



