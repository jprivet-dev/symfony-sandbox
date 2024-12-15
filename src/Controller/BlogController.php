<?php

namespace App\Controller;

use App\Entity\Post;
use App\Repository\PostRepository;
use App\Repository\TagRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/blog')]
class BlogController extends AbstractController
{
    #[Route('/', name: 'app_blog')]
    public function index(TagRepository $tagRepository, PostRepository $postRepository, Request $request): Response
    {
        $page = $request->query->getInt('page', 1);

        return $this->render('blog.html.twig', [
            'tags' => $tagRepository->findAllWithPostsCount(),
            'posts' => $postRepository->findAllPaginate($page),
        ]);
    }

    #[Route('/{slug:post}', name: 'app_blog_post_by_slug')]
    public function postBySlug(Post $post): Response
    {
        return $this->render('post.html.twig', [
            'post' => $post,
        ]);
    }
}
