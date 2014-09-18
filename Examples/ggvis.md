

<script src="../gitbook/plugins/gitbook-plugin-ggvis/lib/jquery/jquery.min.js"></script>
<link href="../gitbook/plugins/gitbook-plugin-ggvis/lib/jquery-ui/css/smoothness/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
<script src="../gitbook/plugins/gitbook-plugin-ggvis/lib/jquery-ui/js/jquery-ui-1.10.4.custom.min.js"></script>
<script src="../gitbook/plugins/gitbook-plugin-ggvis/lib/d3/d3.min.js"></script>
<script src="../gitbook/plugins/gitbook-plugin-ggvis/lib/vega/vega.min.js"></script>
<script src="../gitbook/plugins/gitbook-plugin-ggvis/lib/lodash/lodash.min.js"></script>
<script>var lodash = _.noConflict();</script>
<link href="../gitbook/plugins/gitbook-plugin-ggvis/ggvis/css/ggvis.css" rel="stylesheet" />
<script src="../gitbook/plugins/gitbook-plugin-ggvis/ggvis/js/ggvis.js"></script>
<script src="../gitbook/plugins/gitbook-plugin-ggvis/ggvis/js/shiny-ggvis.js"></script>

# ggvis

ggvis



```r
mtcars %>>% ggvis(~mpg, ~wt)
```

<div id="plot_id248051135-container" class="ggvis-output-container">
<div id="plot_id248051135" class="ggvis-output"></div>
<div class="plot-gear-icon">
<nav class="ggvis-control">
<a class="ggvis-dropdown-toggle" title="Controls" onclick="return false;"></a>
<ul class="ggvis-dropdown">
<li>
Renderer: 
<a id="plot_id248051135_renderer_svg" class="ggvis-renderer-button" onclick="return false;" data-plot-id="plot_id248051135" data-renderer="svg">SVG</a>
 | 
<a id="plot_id248051135_renderer_canvas" class="ggvis-renderer-button" onclick="return false;" data-plot-id="plot_id248051135" data-renderer="canvas">Canvas</a>
</li>
<li>
<a id="plot_id248051135_download" class="ggvis-download" data-plot-id="plot_id248051135">Download</a>
</li>
</ul>
</nav>
</div>
</div>
<script type="text/javascript">
var plot_id248051135_spec = {
	"data" : [
		{
			"name" : ".0",
			"format" : {
				"type" : "csv",
				"parse" : {
					"mpg" : "number",
					"wt" : "number"
				}
			},
			"values" : "\"mpg\",\"wt\"\n21,2.62\n21,2.875\n22.8,2.32\n21.4,3.215\n18.7,3.44\n18.1,3.46\n14.3,3.57\n24.4,3.19\n22.8,3.15\n19.2,3.44\n17.8,3.44\n16.4,4.07\n17.3,3.73\n15.2,3.78\n10.4,5.25\n10.4,5.424\n14.7,5.345\n32.4,2.2\n30.4,1.615\n33.9,1.835\n21.5,2.465\n15.5,3.52\n15.2,3.435\n13.3,3.84\n19.2,3.845\n27.3,1.935\n26,2.14\n30.4,1.513\n15.8,3.17\n19.7,2.77\n15,3.57\n21.4,2.78"
		},
		{
			"name" : "scale/x",
			"format" : {
				"type" : "csv",
				"parse" : {
					"domain" : "number"
				}
			},
			"values" : "\"domain\"\n9.225\n35.075"
		},
		{
			"name" : "scale/y",
			"format" : {
				"type" : "csv",
				"parse" : {
					"domain" : "number"
				}
			},
			"values" : "\"domain\"\n1.31745\n5.61955"
		}
	],
	"scales" : [
		{
			"name" : "x",
			"domain" : {
				"data" : "scale/x",
				"field" : "data.domain"
			},
			"zero" : false,
			"nice" : false,
			"clamp" : false,
			"range" : "width"
		},
		{
			"name" : "y",
			"domain" : {
				"data" : "scale/y",
				"field" : "data.domain"
			},
			"zero" : false,
			"nice" : false,
			"clamp" : false,
			"range" : "height"
		}
	],
	"marks" : [
		{
			"type" : "symbol",
			"properties" : {
				"update" : {
					"fill" : {
						"value" : "#000000"
					},
					"size" : {
						"value" : 50
					},
					"x" : {
						"scale" : "x",
						"field" : "data.mpg"
					},
					"y" : {
						"scale" : "y",
						"field" : "data.wt"
					}
				},
				"ggvis" : {
					"data" : {
						"value" : ".0"
					}
				}
			},
			"from" : {
				"data" : ".0"
			}
		}
	],
	"width" : null,
	"height" : null,
	"legends" : [],
	"axes" : [
		{
			"type" : "x",
			"scale" : "x",
			"orient" : "bottom",
			"layer" : "back",
			"grid" : true,
			"title" : "mpg"
		},
		{
			"type" : "y",
			"scale" : "y",
			"orient" : "left",
			"layer" : "back",
			"grid" : true,
			"title" : "wt"
		}
	],
	"padding" : null,
	"ggvis_opts" : {
		"keep_aspect" : false,
		"resizable" : true,
		"padding" : {},
		"duration" : 250,
		"renderer" : "svg",
		"hover_duration" : 0,
		"width" : null,
		"height" : null
	},
	"handlers" : null
};
ggvis.getPlot("plot_id248051135").parseSpec(plot_id248051135_spec);
</script>
