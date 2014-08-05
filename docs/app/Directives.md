# directives.coffee

#### Classes
  
* [BaseDirective](#BaseDirective)
  
* [ErrorDirective](#ErrorDirective)
  
* [ResourceDirective](#ResourceDirective)
  
* [EmbedDirective](#EmbedDirective)
  
* [ModeDirective](#ModeDirective)
  
* [PartialDirective](#PartialDirective)
  
* [MarkdownDirective](#MarkdownDirective)
  
* [ProcDirective](#ProcDirective)
  
* [StepsDirective](#StepsDirective)
  
* [StepDirective](#StepDirective)
  
* [RootDirective](#RootDirective)
  






## Classes
  
### <a name="BaseDirective">[BaseDirective](BaseDirective)</a>
    
      
#### *[extends AngularBase](#AngularBase)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="constructor">constructor()</a>

      
##### <a name="link">link(scope, elm, attrs, controller)</a>

      
##### <a name="__factory">_\_factory(cls)</a>
Return a link function that 
instantiates the DiretiveCls on each call

      
##### <a name="__module_install_function">_\_module\_install\_function(cls, module)</a>

      
    
  
### <a name="ErrorDirective">[ErrorDirective](ErrorDirective)</a>
    
      
#### *[extends BaseDirective](#BaseDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="link">link(scope, elm, attrs, controller)</a>

      
    
  
### <a name="ResourceDirective">[ResourceDirective](ResourceDirective)</a>
    
      
#### *[extends BaseDirective](#BaseDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="link">link(scope, elm, attrs, controller)</a>

      
##### <a name="get_resource">get\_resource()</a>

      
##### <a name="on_resource_watcher">on\_resource\_watcher(resource, old_resource)</a>

      
##### <a name="on_resource">on\_resource()</a>

      
##### <a name="display">display()</a>
Append resource to @$elm

      
    
  
### <a name="EmbedDirective">[EmbedDirective](EmbedDirective)</a>
    
      
#### *[extends ResourceDirective](#ResourceDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="detect_embed_loop">detect\_embed\_loop()</a>

      
##### <a name="display_embed_loop">display\_embed\_loop()</a>

      
##### <a name="display">display()</a>

      
    
  
### <a name="ModeDirective">[ModeDirective](ModeDirective)</a>
    
      
#### *[extends ResourceDirective](#ResourceDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="get_mode">get\_mode()</a>

      
##### <a name="on_mode_watcher">on\_mode\_watcher(mode, old_mode)</a>

      
##### <a name="on_mode">on\_mode()</a>

      
##### <a name="on_resource">on\_resource()</a>

      
    
  
### <a name="PartialDirective">[PartialDirective](PartialDirective)</a>
    
      
#### *[extends ModeDirective](#ModeDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="get_partial">get\_partial()</a>

      
##### <a name="on_partial_watcher">on\_partial\_watcher(partial, old_partial)</a>

      
##### <a name="on_partial">on\_partial()</a>

      
##### <a name="on_mode">on\_mode()</a>

      
    
  
### <a name="MarkdownDirective">[MarkdownDirective](MarkdownDirective)</a>
    
      
#### *[extends PartialDirective](#PartialDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="display">display()</a>

      
    
  
### <a name="ProcDirective">[ProcDirective](ProcDirective)</a>
    
      
#### *[extends PartialDirective](#PartialDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="watch_visible">watch\_visible()</a>

      
##### <a name="on_visible_watcher">on\_visible\_watcher(visible, old_visible)</a>

      
##### <a name="on_visible">on\_visible()</a>

      
##### <a name="show">show()</a>

      
##### <a name="hide">hide()</a>

      
##### <a name="display">display()</a>

      
##### <a name="display_static">display\_static()</a>
Link to first of a series of steps panels
append to procs_div

      
##### <a name="on_partial">on\_partial()</a>

      
    
  
### <a name="StepsDirective">[StepsDirective](StepsDirective)</a>
    
      
#### *[extends PartialDirective](#PartialDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="step_watcher">step\_watcher()</a>

      
##### <a name="on_step_watcher">on\_step\_watcher(step, old_step)</a>

      
##### <a name="on_step">on\_step()</a>

      
##### <a name="hide_all_steps">hide\_all\_steps()</a>

      
##### <a name="on_parent_hide">on\_parent\_hide()</a>

      
##### <a name="show_current_step">show\_current\_step()</a>

      
##### <a name="install_partial">install\_partial()</a>

      
##### <a name="display_title">display\_title()</a>

      
##### <a name="display_steps">display\_steps()</a>

      
##### <a name="display_steps_static">display\_steps\_static()</a>

      
##### <a name="display">display()</a>

      
##### <a name="display_static">display\_static()</a>

      
##### <a name="on_partial">on\_partial()</a>

      
    
  
### <a name="StepDirective">[StepDirective](StepDirective)</a>
    
      
#### *[extends ModeDirective](#ModeDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="set_canvas_id">set\_canvas\_id()</a>

      
##### <a name="add_canvas_note">add\_canvas\_note(note)</a>

      
##### <a name="add_canvas_notes">add\_canvas\_notes()</a>

      
##### <a name="scale_image">scale\_image()</a>

      
##### <a name="add_image">add\_image()</a>

      
##### <a name="image_fetcher">image\_fetcher(image)</a>

      
##### <a name="populate_canvas">populate\_canvas()</a>

      
##### <a name="step_titles_watcher">step\_titles\_watcher()</a>

      
##### <a name="on_step_titles">on\_step\_titles(ready, old_ready)</a>

      
##### <a name="on_mode">on\_mode()</a>

      
##### <a name="display">display()</a>

      
    
  
### <a name="RootDirective">[RootDirective](RootDirective)</a>
    
      
#### *[extends ResourceDirective](#ResourceDirective)*
      
    
    
    
    
#### Instance Methods          
      
##### <a name="get_path">get\_path()</a>

      
##### <a name="on_path_watcher">on\_path\_watcher(path, old_path)</a>

      
##### <a name="on_path">on\_path()</a>
Re-initialize and watch resource

      
##### <a name="get_search">get\_search()</a>

      
##### <a name="on_search_watcher">on\_search\_watcher(search, old_search)</a>

      
##### <a name="on_search">on\_search()</a>

      
##### <a name="link">link(scope, elm, attrs, controller)</a>
Avoid ResourceDirective.link, which starts with resource watcher

      
    
  



