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
package org.as3commons.ui.layout.shortcut {

	import org.as3commons.ui.layout.framework.core.init.CellConfigInitObject;

	/**
	 * Shortcut to create a <code>CellConfig</code> object.
	 * 
	 * @param args List of configuration parameters.
	 * @author Jens Struwe 18.03.2011
	 */
	public function cellconfig(...args) : CellConfigInitObject {
		var c : CellConfigInitObject = new CellConfigInitObject();

		for (var i : uint = 0; i < args.length; i += 2) {
			if (args[i] is String) {
				if (args[i] == "hIndex") {
					c.hIndex = args[i + 1];

				} else if (args[i] == "vIndex") {
					c.vIndex = args[i + 1];

				} else {
					try {
						c.cellConfig[args[i]] = args[i + 1];
					} catch (e : Error) {
					}
				}
			}
		}

		return c;
	}
}
