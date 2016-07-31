# Ruby Web Parser
##Ruby script parse web-pages with information about pets food and write it to the csv-file. 

Program gets 2 params:
 
- link to a food category web-page 
- the name of a result-file.

This is an exapmle of the category page of site, that sales goods for pets: http://www.viovet.co.uk/Pet_Foods_Diets-Dogs-Hills_Pet_Nutrition-Hills_Prescription_Diets/c233_234_2678_93/category.html

For every product program takes:

1. title
2. price
3. image url
4. delivery time
5. product code

This is an example of a product page: http://www.viovet.co.uk/Pet_Foods_Diets-Dogs-Hills_Pet_Nutrition-Hills_Prescription_Diets-Hills_Prescription_H/D_Diets/c233_234_2678_93_98/category.html.
 
Such pages are called multiproduct-pages. It meams, one page keeps data about different kinds of product. In this case every product can have a different weight: Dry » 5kg Bag, Wet » 12 x 370g Cans and so on. Two rows from this page would be added to the result file.

