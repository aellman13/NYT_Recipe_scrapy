from scrapy import Spider, Request
from nyt_recipes.items import NytrecipesItem
import re

class NYTSpider(Spider):
	name = 'nyt_spider'
	allowed_urls = ['https://www.cooking.nytimes.com/']
	start_urls   = ['https://cooking.nytimes.com/collections?page=1']

	def parse(self, response):

		total_items = int(response.xpath('//span[@class="result-details"]/text()').get().strip())
		page_items  = len(response.xpath('//div[@class="cards clearfix"]//a/@href').getall())
		num_pages   = total_items//page_items + 1
	
		print('*'*50)
		print(num_pages)
		print('*'*50)
		
		urls = ['https://cooking.nytimes.com/collections?page={}'.format(x) for x in range(1,num_pages+1)]
		
		for url in urls:
			print('*'*50)
			print(url)
			print('*'*50)	
			yield Request(url = url, callback=self.parse_comp_pages)


	def parse_comp_pages(self, response):

		partial_urls = response.xpath('//div[@class="cards clearfix"]//a/@href').getall()

		collection_urls = ['https://cooking.nytimes.com'+url for url in partial_urls]
		

		for url in collection_urls:
			print('*'*50)
			print(url)
			print('*'*50)
			yield Request(url = url, callback = self.parse_recipe_urls)

	def parse_recipe_urls(self, response):

		partial_urls = response.xpath('//div[@class="recipes track-card-params"]/article/div[1]/a[1]/@href').getall()
		recipe_urls  = ['https://cooking.nytimes.com'+url for url in partial_urls]

		for url in recipe_urls:
			print('*'*50)
			print(url)
			print('*'*50)
			yield Request(url=url, callback=self.parse_recipe_page)

	def parse_recipe_page(self, response):
		# extract recipe title
		title = response.xpath('//h1[@class="recipe-title title name"]/text()').get().strip()
		
		# extract the yield number in string form from yield string 
		
		yield_full   = response.xpath('//span[@class="recipe-yield-value"]/text()').getall()[0]
		yield_num    = re.findall(r"[\d+\d\/\d]+",yield_full)
		
		yield_metric = re.findall(r"[A-Za-z]+", yield_full)[-1]

		time_full    = response.xpath('//span[@class="recipe-yield-value"]/text()').getall()[1]
		time_num     = re.findall(r"[\d+\d\/\d]+",time_full)
		
		time_metric  = re.findall(r"\b(?:minutes|hours|hour|day|days)\b", time_full)
		try:
			cook_category = response.xpath('//div[@class="grid-wrap"]/article/header/a/text()').get().strip()
		except:
			cook_category = None
		try:
			description  = response.xpath('//div[@class="topnote"]/p/text()').getall()
		except:
			description  = None
		author       = response.xpath('//span[@itemprop="author"]/text()').get().strip()
		recipe_title = response.xpath('//h1[@class="recipe-title title name"]/text()').get().strip()
		rating 		 = response.xpath('//span[@itemprop="ratingValue"]/text()').get()
		ingredient_amount = [x.strip() for x in response.xpath('//span[@class="quantity"]/text()').getall()]
		ingredient_name   = [x.strip()+'---' for x in response.xpath('//span[@class="ingredient-name"]/text()').getall()]
		cook_instructions = [x.strip()+'---' for x in response.xpath('//ol[@class="recipe-steps"]/li/text()').getall()]
		url 			= response.xpath('//meta[@property="og:url"]/@content').get()
		#username = response.xpath('//span[@class="nytc---notessection---noteOwner"]/text()').getall()
		tags         = response.xpath('//div[@class="tags-nutrition-container"]/a/text()').getall()
		try:
			picture_src  = response.xpath('//div[@class="recipe-intro"]/div[1]/img/@src').get()
		except:
			picture_src = None
		item = NytrecipesItem()
		item['yield_metric'] 	= yield_metric
		item['time_num'] 		= time_num
		item['time_metric'] 	= time_metric
		item['cook_category'] 	= cook_category
		item['description'] 	= description
		item['author'] 			= author
		item['recipe_title'] 	= recipe_title
		item['rating'] 			= rating
		item['ingredient_amount'] = ingredient_amount
		item['ingredient_name'] = ingredient_name
		item['cook_instructions'] = cook_instructions
		item['tags'] 			= tags
		item['picture_src'] 	= picture_src
		item['url']				= url
		yield item




		







		



