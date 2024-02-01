import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";

using TypeSpec.Http;
using TypeSpec.Rest;

@service({
    title: "Book Store Service",
})
@server("https://example.com", "The service endpoint")
@doc("This is a Book Store Web API")
namespace BookStore;

@route("/books")
interface Books {
  @route("/")
  @get list(): Book[] | UnknownError;

  @route("/{id}")
  @get index(@path id: int32): 
    | Book 
    | { @statusCode _: 400, ...Error<"bad.param", "parameter error">}
    | { @statusCode _: 404, ...Error<"notFound", "the book is not found">}
    | UnknownError
}

model Book {
  id: int32;
  @maxLength(13)
  isbn_code: string;
  @maxLength(128)
  title: string;
  authors: Author[];
  publisher: Publisher;
  publish_date: utcDateTime;
}

model Author {
  id: int32;
  @maxLength(128)
  name: string;
}

model Publisher {
  id: int32;
  @maxLength(128)
  name: string;
}

@error
model Error<CODE extends string = string, MSG extends string = string> {
  code: CODE;
  message: MSG;
}

@error
model UnknownError extends Error<"unknown", "Unknown Error"> {
  @statusCode _: 500
}