/**************************************************************************
# AUTHOR: Debra Wilkie
# CLASS: CS362 Software Engineering II
# DATE: October 14, 2016
# This is an example of JUnit testing for a Blackjack game simulation 
*************************************************************************/

package edu.osu.cs362;

import static org.junit.Assert.*;
import org.junit.Test;


public class WarmupTest  {
    @Test
    public void testFindIntegerExample() {

		int result = WarmUp.findInteger(new int[] { 1, 2, 3, 4, 5 }, 100);
		assertEquals(result, -1);

		for (int i = 1; i < 5; i++) {
			int result2 = WarmUp.findInteger(new int[] { 1, 2, 3, 4, 5 }, i + 1);
			assertEquals("findInteger(new int[]{1,2,3,4,5}," + i + ")", result2, i);
		}
	}

//I am creating a new array with only 1-5 and no Zeros to see if the test will work
//I am looping through the array 
    @Test
    public void testLastZero() {
		int result = WarmUp.lastZero(new int[] { 1, 2, 3, 4, 5 });
		assertEquals(result, -1);
		
		for (int i = 5; i < 1; i--) {
			int result2 = WarmUp.lastZero(new int[] { 1, 2, 3, 4, 5 });
			assertEquals("lastZero(new int[]{1,2,3,4,5}, result2);
		}
	}

//I am creating a new array with only 1-5 and the integer 10 see if the test will work
	@Test
    public void testLast() {
		int result = WarmUp.last(new int[] { 1, 2, 3, 4, 5 }, 10);
		assertEquals(result, -1);
		
		for (int i = 1; i < 5; i--) {
			int result2 = WarmUp.last(new int[] { 1, 2, 3, 4, 5 }, i - 1);
			assertEquals("last(new int[]{1,2,3,4,5}," + i + ")", result2, i);
		}
	}

//I am creating a new array with only negative numbers to see if the test will work	
	@Test
    public void testPositive() {
		int result = WarmUp.last(new int[] { -1, -2, -3, -4, -5 });
		assertEquals(result, -1);
		
		for (int i = 1; i < 5; i++) {
			int result2 = WarmUp.positive(new int[] { -1, -2, -3, -4, -5 });
			assertEquals("positive(new int[]{1,2,3,4,5}, result2);
		}
	}

//I am creating a new array with only negative even numbers to see if the test will work
	@Test
    public void testOddOrPos() {
		int result = WarmUp.last(new int[] { -2, -4, -6, -8 });
		assertEquals(result, -1);

		for (int i = 1; i < 4; i++) {
			int result2 = WarmUp.OddOrPos(new int[] { -2, -4, -6, -8 });
			assertEquals("oddOrPos(new int[]{-2, -4, -6, -8}, result2);
		}
	}

}




