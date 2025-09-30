import os
import sys
import argparse
from pathlib import Path
try:
    from pypdf import PdfReader, PdfWriter
except ImportError:
    try:
        from PyPDF2 import PdfReader, PdfWriter
    except ImportError:
        print("Error: Please install pypdf or PyPDF2")
        print("Run: pip install pypdf")
        sys.exit(1)

class PDFMerger:
    def __init__(self):
        """Initialize PDF Merger"""
        self.pdf_writer = PdfWriter()
        self.merged_count = 0
    
    def find_pdf_files(self, directory_path):
        """
        Find all PDF files in the specified directory
        
        Args:
            directory_path (str): Path to directory containing PDF files
            
        Returns:
            list: Sorted list of PDF file paths
        """
        directory = Path(directory_path)
        if not directory.exists():
            raise FileNotFoundError(f"Directory not found: {directory_path}")
        
        if not directory.is_dir():
            raise NotADirectoryError(f"Path is not a directory: {directory_path}")
        
        # Find all PDF files and sort them alphabetically
        pdf_files = sorted([f for f in directory.glob("*.pdf") if f.is_file()])
        
        if not pdf_files:
            raise ValueError(f"No PDF files found in directory: {directory_path}")
        
        return pdf_files
    
    def merge_pdfs(self, pdf_files, output_path):
        """
        Merge multiple PDF files into a single PDF
        
        Args:
            pdf_files (list): List of PDF file paths to merge
            output_path (str): Path for the merged output PDF file
            
        Returns:
            bool: True if merge successful, False otherwise
        """
        try:
            print(f"Starting to merge {len(pdf_files)} PDF files...")
            
            for pdf_file in pdf_files:
                try:
                    print(f"Processing: {pdf_file.name}")
                    pdf_reader = PdfReader(str(pdf_file))
                    
                    # Add all pages from current PDF to writer
                    for page_num, page in enumerate(pdf_reader.pages):
                        self.pdf_writer.add_page(page)
                        print(f"  Added page {page_num + 1}")
                    
                    self.merged_count += 1
                    print(f"  Successfully processed {pdf_file.name}")
                    
                except Exception as e:
                    print(f"  Error processing {pdf_file.name}: {str(e)}")
                    continue
            
            # Write merged PDF to output file
            with open(output_path, 'wb') as output_file:
                self.pdf_writer.write(output_file)
            
            print(f"\nMerge completed successfully!")
            print(f"Merged {self.merged_count} PDF files into: {output_path}")
            return True
            
        except Exception as e:
            print(f"Error during merge process: {str(e)}")
            return False
    
    def merge_directory(self, input_directory, output_filename=None):
        """
        Merge all PDF files in a directory
        
        Args:
            input_directory (str): Directory containing PDF files to merge
            output_filename (str, optional): Name for output file. Defaults to 'merged_pdfs.pdf'
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            # Find PDF files
            pdf_files = self.find_pdf_files(input_directory)
            print(f"Found {len(pdf_files)} PDF files to merge:")
            for pdf_file in pdf_files:
                print(f"  - {pdf_file.name}")
            
            # Set output filename
            if not output_filename:
                output_filename = "merged_pdfs.pdf"
            
            # Ensure output filename has .pdf extension
            if not output_filename.lower().endswith('.pdf'):
                output_filename += '.pdf'
            
            # Create output path in the same directory
            output_path = Path(input_directory) / output_filename
            
            # Check if output file already exists
            if output_path.exists():
                response = input(f"Output file '{output_path}' already exists. Overwrite? (y/n): ")
                if response.lower() != 'y':
                    print("Merge cancelled.")
                    return False
            
            # Perform merge
            return self.merge_pdfs(pdf_files, output_path)
            
        except (FileNotFoundError, NotADirectoryError, ValueError) as e:
            print(f"Error: {str(e)}")
            return False
        except Exception as e:
            print(f"Unexpected error: {str(e)}")
            return False

def main():
    """Main function with command-line interface"""
    parser = argparse.ArgumentParser(
        description="Merge all PDF files in a directory into a single PDF file",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python mergepdf.py /path/to/pdfs
  python mergepdf.py /path/to/pdfs -o combined.pdf
  python mergepdf.py . -o report.pdf
        """
    )
    
    parser.add_argument(
        'directory',
        help='Directory containing PDF files to merge'
    )
    
    parser.add_argument(
        '-o', '--output',
        default='merged_pdfs.pdf',
        help='Output filename for merged PDF (default: merged_pdfs.pdf)'
    )
    
    # Parse arguments
    args = parser.parse_args()
    
    try:
        # Initialize merger
        merger = PDFMerger()
        
        # Perform merge
        success = merger.merge_directory(args.directory, args.output)
        
        if success:
            print(f"\n✅ PDF merge completed successfully!")
            sys.exit(0)
        else:
            print(f"\n❌ PDF merge failed!")
            sys.exit(1)
            
    except KeyboardInterrupt:
        print(f"\n\nMerge cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"Fatal error: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
