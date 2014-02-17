import java.util.Random;

/*	Luhn.java
	Author: William Woodruff
	------------------------
	Description:
	Luhn.java provides an implementation of the Luhn-10 (aka Modulus-10) generation and validation algorithms.
	Generation is performed by the generate() function, which creates an array of n ints in the range {0,9}
	that are Luhn-10 valid.
	Validation is performed by the check() function, which returns true or false depending on the validity of 
	the array of ints provided.

	Notes:
	Luhn-10 isn't secure. It's a quick way to detect single digit changes in number strings.
	Because 10% of all random int strings are Luhn-10 valid, creating correct strings in real time is computationally trivial.
	It's often used by credit card and banking companies, as it is simple to implement and makes
	attacks by random guessing difficult to carry out.

	License:
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT

*/

public class Luhn
{
	public static void main(String[] args)
	{
		/* examples

		int[] validNums = generate(16);

		int[] isItValid = {1, 2, 3, 4, 5, 8, 1, 2, 6, 2, 8};
		boolean flag = check(isItValid);

		*/
	}

	/*  generate(int len)
		argument: int len, the length of the Luhn-string to generate
		return: an array of n ints in range {0-9} whose values are Luhn-10 valid.
	*/
	public static int[] generate(int len)
	{
		Random rgen = new Random(); //instantiate the PRNG
		int[] arr = new int[len]; //allocate an array of n ints

		for (int i = 0; i < arr.length - 1; i++)
		{
			arr[i] = rgen.nextInt(10); //fill all indices of the array except the last
		}

		boolean found = false;
		int j = 0;
		do //loop incrementally until the array is Luhn-10 valid
		{
			arr[arr.length - 1] = j;
			found = check(arr);
			j++;
		} while (!found);

		return arr;
	}

	/*	check(int[] numbers)
		argument: int[] numbers, the array of integers to evaluate
		return: true if numbers is a valid sequence, false otherwise
	*/
	public static boolean check(int[] numbers)
	{
		if (numbers != null)
		{
			int sum = 0;
			String[] doubles;

			if (numbers.length % 2 == 0) //allocate room for the doubled numbers based upon size
				doubles = new String[numbers.length / 2];
			else
				doubles = new String[(numbers.length / 2) + 1];
			
			int k = 0;
			for (int i = 0; i < numbers.length; i++)
			{
				if (i % 2 == 0)
				{
					doubles[k] = String.valueOf(numbers[i] * 2); //add doubles to the String array
					k++;
				}
				else
					sum += numbers[i]; //add non-doubles to sum
			}
				
			for (int j = 0; j < doubles.length; j++)
			{
				if (doubles[j].length() == 1) //if the number is less than 10 ("10")
					sum += Integer.valueOf(doubles[j]);
				else //sum each individual digit
				{
					sum += Integer.valueOf(doubles[j].substring(0, 1));
					sum += Integer.valueOf(doubles[j].substring(1, 2));
				}
			}
				
			return (sum % 10 == 0);
		}
		else return false;
	}
}