/**
 * Copyright 2011 The original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.ui.layout.framework.core.config {

	import org.as3commons.ui.layout.CellConfig;

	/**
	 * Util to merge two different cell configs.
	 * 
	 * @author Jens Struwe 23.03.2011
	 */
	public class CellConfigMerge {
		
		/**
		 * Merge.
		 * 
		 * @param toConfig The config to merge to.
		 * @param fromConfig The config to merge from.
		 * @return The merged config.
		 */
		public static function merge(toConfig : CellConfig, fromConfig : CellConfig) : CellConfig {
			if (!fromConfig) return toConfig;

			if (!toConfig) toConfig = new CellConfig();
			
			if (fromConfig.propertyExplicitlySet("width")) toConfig.width = fromConfig.width;
			if (fromConfig.propertyExplicitlySet("height")) toConfig.height = fromConfig.height;
			if (fromConfig.propertyExplicitlySet("marginX")) toConfig.marginX = fromConfig.marginX;
			if (fromConfig.propertyExplicitlySet("marginY")) toConfig.marginY = fromConfig.marginY;
			if (fromConfig.propertyExplicitlySet("offsetX")) toConfig.offsetX = fromConfig.offsetX;
			if (fromConfig.propertyExplicitlySet("offsetY")) toConfig.offsetY = fromConfig.offsetY;
			if (fromConfig.propertyExplicitlySet("hAlign")) toConfig.hAlign = fromConfig.hAlign;
			if (fromConfig.propertyExplicitlySet("vAlign")) toConfig.vAlign = fromConfig.vAlign;

			return toConfig;
		}

	}
}
