<?php

namespace App\Controller;

use App\Entity\Post;
use App\Entity\Tag;
use App\Mapper\TagDtoMapper;
use App\Repository\PostRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/blog')]
class BlogController extends AbstractController
{
    #[Route('/posts/{slug:post}', name: 'app_blog_post')]
    public function postBySlug(Post $post): Response
    {
        return $this->render('post.html.twig', ['post' => $post]);
    }

    private function getCurrentPage(Request $request): int
    {
        return $request->query->getInt('page', 1);
    }

    #[Route('/posts', name: 'app_blog_posts')]
    public function posts(PostRepository $postRepository): Response
    {
        return $this->render('posts/index.html.twig', [
            'posts' => $postRepository->findAll(),
        ]);
    }

    #[Route('/posts-by-tag/{id:tag}', name: 'app_blog_posts_by_tag_id')]
    public function postsByTagId(Tag $tag, TagDtoMapper $tagDtoMapper, PostRepository $postRepository, Request $request): Response
    {
        return $this->render('blog.html.twig', [
            'currentTag' => $tag,
            'tags' => $tagDtoMapper->findAllWithPostsCount(),
            'posts' => $postRepository->findAllByTagPaginate($tag, $this->getCurrentPage($request)),
            'postsCount' => $postRepository->count(),
        ]);
    }

    #[Route('/posts-by-tag/', name: 'app_blog')]
    public function latest(TagDtoMapper $tagDtoMapper, PostRepository $postRepository, Request $request): Response
    {
        return $this->render('blog.html.twig', [
            'tags' => $tagDtoMapper->findAllWithPostsCount(),
            'posts' => $postRepository->findAllPaginate($this->getCurrentPage($request)),
            'postsCount' => $postRepository->count(),
        ]);
    }
}
