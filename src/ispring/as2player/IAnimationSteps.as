
package ispring.as2player
{
	public interface IAnimationSteps
	{
		function get stepsCount():Number;
		function get duration():Number;
		function getStep(index:Number):IAnimationStep;
	}
}
