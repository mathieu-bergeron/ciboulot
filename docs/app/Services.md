# services.coffee

#### Classes
  
* [BaseService](#BaseService)
  
* [BaseInstance](#BaseInstance)
  
* [PathManipulator](#PathManipulator)
  
* [MarkdownService](#MarkdownService)
  
* [FetchResourceService](#FetchResourceService)
  
* [FetchPartialService](#FetchPartialService)
  






## Classes
  
### <a name="BaseService">[BaseService](BaseService)</a>
    
      
#### *[extends AngularBase](#AngularBase)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="__module_install_function">_\_module\_install\_function(cls, module)</a>
NOTE: ServiceCls.__factory called only once
      when registred via module.service

      
    
  
### <a name="BaseInstance">[BaseInstance](BaseInstance)</a>
    
      
#### *[extends AngularBase](#AngularBase)*
      
    
    Same as BaseService, but __factory instantiates 
the class

    
    
#### Instance Methods          
      
##### <a name="__factory">_\_factory(cls)</a>

      
##### <a name="__module_install_function">_\_module\_install\_function(cls, module)</a>

      
    
  
### <a name="PathManipulator">[PathManipulator](PathManipulator)</a>
    
      
#### *[extends BaseInstance](#BaseInstance)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="join_paths">join\_paths(path1, path2)</a>

      
##### <a name="resolve_path">resolve\_path(src, path)</a>

      
##### <a name="id_of_path">id\_of\_path(path)</a>

      
    
  
### <a name="MarkdownService">[MarkdownService](MarkdownService)</a>
    
      
#### *[extends BaseService](#BaseService)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="constructor">constructor(@markdown_text, @src, @mode)</a>

      
##### <a name="initialize">initialize()</a>

      
##### <a name="process_line">process\_line(line)</a>

      
##### <a name="html_of_directive">html\_of\_directive(directive)</a>

      
##### <a name="process_name_arg">process\_name\_arg(name_arg)</a>

      
##### <a name="process_markdown_text">process\_markdown\_text(markdown_text)</a>

      
##### <a name="install_hooks">install\_hooks()</a>

      
##### <a name="convert_html">convert\_html()</a>

      
##### <a name="get_html">get\_html()</a>

      
    
  
### <a name="FetchResourceService">[FetchResourceService](FetchResourceService)</a>
    
      
#### *[extends BaseService](#BaseService)*
      
    
    
    
    
  
### <a name="FetchPartialService">[FetchPartialService](FetchPartialService)</a>
    
      
#### *[extends BaseService](#BaseService)*
      
    
    
    
    
  



