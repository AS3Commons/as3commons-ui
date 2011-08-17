<?php
	
	/*
	*	Check GET
	*/

	$config_numBoxes = 0;
	if (isset($_GET['num_boxes']) && is_numeric($_GET['num_boxes'])) {
		$config_numBoxes = round($_GET['num_boxes']);
		$config_numBoxes = max(0, min(8, $config_numBoxes));
	}
	
	$config_numTabEnabledBoxes = $config_numBoxes;
	if (isset($_GET['num_tab_enabled_boxes']) && is_numeric($_GET['num_tab_enabled_boxes'])) {
		$config_numTabEnabledBoxes = round($_GET['num_tab_enabled_boxes']);
		$config_numTabEnabledBoxes = max(0, min($config_numBoxes, $config_numTabEnabledBoxes));
	}
	
	$config_seamless = true;
	if (isset($_GET['seamless']) && $_GET['seamless'] == "false") {
		$config_seamless = false;
	}
	
	$config_preventDefault = false;
	if (isset($_GET['prevent_default']) && $_GET['prevent_default'] == "true") {
		$config_preventDefault = true;
	}
	
	$config_focusToStage = false;
	if (isset($_GET['focus_to_stage']) && $_GET['focus_to_stage'] == "true") {
		$config_focusToStage = true;
	}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>Fun with focus, tabbing and IE</title>

	<link rel="stylesheet" type="text/css" href="focustest.css" />

	<script type="text/javascript">
		function exampleSelected() {
			var select = document.getElementById("exampleSelect");
			if (!select.selectedIndex) return;
			select.form.submit();
		}
	</script>

	<script type="text/javascript" src="swfobject/swfobject.js"></script>
	<script type="text/javascript">
		var flashvars = {};
		flashvars.numBoxes = <?php echo $config_numBoxes; ?>;
		flashvars.numEnabledBoxes = <?php echo $config_numTabEnabledBoxes; ?>;
		flashvars.preventDefault = <?php echo $config_preventDefault ? "true" : "false"; ?>;
		flashvars.focusToStage = <?php echo $config_focusToStage ? "true" : "false"; ?>;
		
		var params = {};
		params.scale = "noscale";
		params.salign = "tl";
		params.seamlesstabbing = "<?php echo $config_seamless ? "true" : "false"; ?>";

		swfobject.embedSWF("FocusTest.swf", "movie1", "192", "160", "9.0.0", "expressInstall.swf", flashvars, params);
		swfobject.embedSWF("FocusTest.swf", "movie2", "192", "160", "9.0.0", "expressInstall.swf", flashvars, params);
		swfobject.embedSWF("FocusTest.swf", "movie3", "192", "160", "9.0.0", "expressInstall.swf", flashvars, params);
	</script>

</head>

<body>

	<h1>Fun with focus, tabbing and IE</h1>
	<hr />

	<form method="GET">
	
		<table>
		
			<tr>
				<td>Number of boxes:</td>
				<td><?php echo $config_numBoxes; ?></td>
				<td>
					<?php for ($i = 0; $i < 9; $i++) : ?>
						<?php $checked = $i == $config_numBoxes ? 'checked="true"' : ''; ?>
						<input type="radio" name="num_boxes" value="<?php echo $i; ?>" <?php echo $checked; ?>><span><?php echo $i; ?></span>
					<?php endfor; ?>
				</td>
			</tr>
		
			<tr>
				<td>Number of tab enabled boxes:</td>
				<td><?php echo $config_numTabEnabledBoxes; ?></td>
				<td>
					<?php for ($i = 0; $i < 9; $i++) : ?>
						<?php $checked = $i == $config_numTabEnabledBoxes ? 'checked="true"' : ''; ?>
						<input type="radio" name="num_tab_enabled_boxes" value="<?php echo $i; ?>" <?php echo $checked; ?>><span><?php echo $i; ?></span>
					<?php endfor; ?>
				</td>
			</tr>
		
			<tr>
				<td>Seamless tabbing:</td>
				<td><?php echo $config_seamless ? "true" : "false"; ?></td>
				<td>
					<?php $checked = $config_seamless ? 'checked="true"' : ''; ?>
					<input type="radio" name="seamless" value="true" <?php echo $checked; ?>><span>true</span>
					<?php $checked = !$config_seamless ? 'checked="true"' : ''; ?>
					<input type="radio" name="seamless" value="false" <?php echo $checked; ?>><span>false</span>
				</td>
			</tr>
		
			<tr>
				<td>Prevent focus change:</td>
				<td><?php echo $config_preventDefault ? "true" : "false"; ?></td>
				<td>
					<?php $checked = $config_preventDefault ? 'checked="true"' : ''; ?>
					<input type="radio" name="prevent_default" value="true" <?php echo $checked; ?>><span>true</span>
					<?php $checked = !$config_preventDefault ? 'checked="true"' : ''; ?>
					<input type="radio" name="prevent_default" value="false" <?php echo $checked; ?>><span>false</span>
				</td>
			</tr>
		
			<tr>
				<td>Set default focus to stage:</td>
				<td><?php echo $config_focusToStage ? "true" : "false"; ?></td>
				<td>
					<?php $checked = $config_focusToStage ? 'checked="true"' : ''; ?>
					<input type="radio" name="focus_to_stage" value="true" <?php echo $checked; ?>><span>true</span>
					<?php $checked = !$config_focusToStage ? 'checked="true"' : ''; ?>
					<input type="radio" name="focus_to_stage" value="false" <?php echo $checked; ?>><span>false</span>
					<br />
					<br />

					<input type="submit" value="Change" onclick="exampleSelected();" />
				</td>
			</tr>
		
		</table>
	
	</form>
	
	<hr />

	<div id="focus_container">

		<?php for ($i = 1; $i < 6; $i++) : ?>
			<input class="focus2" type="button" value="HTML" />
		<?php endfor ?>
		
		<br />

		<div id="movie1"></div>
		<div id="movie2"></div>
		<div id="movie3"></div>

		<br />

		<?php for ($i = 6; $i < 11; $i++) : ?>
			<input class="focus2" type="button" value="HTML" />
		<?php endfor ?>
	</div>

</body>

</html>